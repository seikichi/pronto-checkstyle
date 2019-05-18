require 'pronto'
require 'rexml/document'

module Pronto
  class Checkstyle < Runner
    def run
      return [] unless @patches

      @patches
        .select(&method(:valid_patch?))
        .flat_map(&method(:inspect))
        .compact
    end

    private

    Offence = Struct.new(:path, :line, :message)

    def checkstyle_reports_dir
      ENV['PRONTO_CHECKSTYLE_REPORTS_DIR'] || (raise 'Please set `PRONT_CHECKSTYLE_REPORTS_DIR` to use pronto-checkstyle')
    end

    def valid_patch?(patch)
      patch.additions > 0
    end

    def inspect(patch)
      offences = checkstyle_offences.select { |offence| offence.path == patch.new_file_full_path.to_s }

      offences.flat_map do |offence|
        patch.added_lines
             .select { |line| line.new_lineno == offence.line }
             .map { |line| new_message(offence, line) }
      end
    end

    def checkstyle_offences
      @checkstyle_offences ||=
        begin
          pattern = File.join(checkstyle_reports_dir, '**', '*.xml')
          Dir.glob(pattern).flat_map(&method(:read_checkstyle_report))
        end
    end

    def read_checkstyle_report(path)
      doc = REXML::Document.new(File.read(path))
      REXML::XPath.match(doc, '/checkstyle/file').flat_map do |file|
        REXML::XPath.match(file, 'error').map do |error|
          Offence.new(path_from(file), line_from(error), message_from(error))
        end
      end
    end

    def path_from(file_node)
      file_node.attribute('name').to_s
    end

    def line_from(error_node)
      error_node.attribute('line').to_s.to_i
    end

    def message_from(error_node)
      error_node.attribute('message').to_s
    end

    def new_message(offence, line)
      path = line.patch.delta.new_file[:path]
      Message.new(path, line, :warning, offence.message, nil, self.class)
    end
  end
end
