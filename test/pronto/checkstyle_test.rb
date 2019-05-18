# coding: utf-8
require 'test_helper'

require 'pathname'
require 'tmpdir'

class CheckstyleTest < Test::Unit::TestCase
  DummyRepository = Struct.new('DummyRepository', :path) do
    def blame(_path, _lineno)
      nil
    end
  end

  test '#run returns empty array when patches are nil' do
    checkstyle = Pronto::Checkstyle.new(nil)

    assert_equal([], checkstyle.run)
  end

  test '#run returns messages when violations are found' do
    xml = <<-REPORT_XML
    <?xml version="1.0" encoding="UTF-8"?>
    <checkstyle version="8.17">
      <file name="/path/to/src/main/java/foo/bar/App.java">
        <error line="1" severity="warning" message="FOO"
               source="com.puppycrawl.tools.checkstyle.checks.indentation.IndentationCheck"/>
      </file>
    </checkstyle>
    REPORT_XML

    Dir.mktmpdir do |dir|
      File.write(File.join(dir, 'main.xml'), xml)
      ENV.store('PRONTO_CHECKSTYLE_REPORTS_DIR', dir)

      checkstyle = Pronto::Checkstyle.new(create_new_file_patches('/path/to', 'src/main/java/foo/bar/App.java'))
      messages = checkstyle.run

      assert_equal(1, messages.size)
      assert_equal('src/main/java/foo/bar/App.java', messages[0].path)
      assert_equal('FOO', messages[0].msg)
    end
  end

  private

  def create_new_file_patches(repo_path, new_file_path)
    repo = DummyRepository.new(Pathname.new(repo_path))
    patch = Rugged::Patch.from_strings(nil, "added\n", new_path: new_file_path)
    [Pronto::Git::Patch.new(patch, repo)]
  end
end
