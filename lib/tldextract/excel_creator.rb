require 'roo-xls'
require 'roo'
require 'axlsx_rails'
require 'axlsx'
module TLDExtract
  class ExcelCreator
    def process
      input_file_path = '/Users/satyam.jha/Downloads/Parsed_Domain_Output_file (3).xlsx'
      output_file_path2 = '/Users/satyam.jha/Downloads/output_new_diff_ruby_file3.xlsx'
      private_suffix_ignored = 'ruby_new_domain_parser[private suffixes are ignored]'
      private_suffix_not_ignored = 'ruby_new_domain_parser[private suffixes are not ignored]'

      spreadsheet = Roo::Excelx.new(input_file_path)

      # Find the "Domain" column index
      domain_column_index = 1
      headers = spreadsheet.row(1)

      rows = []
      headers << private_suffix_ignored
      headers << private_suffix_not_ignored
      rows << headers
      (2..spreadsheet.last_row).each do |row_index|
        puts row_index
        row = spreadsheet.row(row_index)
        domain_value = row[domain_column_index - 1].to_s # Adjust for zero-based index

        # Perform logic based on the domain value
        domain_value_when_private_suffix_ignored = TLDExtract.registered_domain(domain_value)
        domain_value_when_private_suffix_not_ignored = TLDExtract.registered_domain(domain_value, include_psl_private_domains: true)

        row << domain_value_when_private_suffix_ignored
        row << domain_value_when_private_suffix_not_ignored
        rows << row
      end

      # Create a new Excel file with the updated data
      Axlsx::Package.new do |p|
        p.workbook.add_worksheet(name: 'Sheet1') do |sheet|
          rows.each do |row|
            if row[3]!=row[5] || row[4]!=row[6]
              sheet.add_row(row)
            end
          end
        end
        p.serialize(output_file_path2)
      end
    end
  end
end
