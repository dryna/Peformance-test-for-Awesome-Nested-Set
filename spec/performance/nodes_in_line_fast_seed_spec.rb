require 'spec_helper'
require 'awesome_nested_set/helper'
require 'rspec-prof'
require 'support/rspec-prof'

require 'spreadsheet'
require 'support/flat_excel_printer'

describe "AwesomeNestedSet" do
  before(:all) do
    self.class.fixtures :categories
  end

  describe "process time" do
    before(:each) do
      RubyProf.measure_mode = RubyProf::PROCESS_TIME
      @n = 1000000
      @test_nodes = []
      Category.delete_all
      left = 0
      right = @n*2+1
      records =""
      records+="(#{1}, 'name#{1}',null,#{left},#{right}),"
      left+=1
      right-=1
      (2..@n).to_a.each do |i|
        records+="(#{i}, 'name#{i}',#{i-1},#{left},#{right}),"
        left+=1
        right-=1
        p i
      end
      records=records.gsub(/,$/, '')
      ActiveRecord::Base.connection.execute("INSERT INTO categories (id, name, parent_id, lft, rgt) VALUES #{records}")
    end

    it "It takes time to build 200 nodes inline as_children" do

      last_node = Category.find_by_id(@n)
      20.times do
        result=RubyProf.profile do
          last_node.ancestors
        end


        printer = ExcelPrinter::FlatExcelPrinter.new(result)
        printer.print('tmp/report_read_ancestors_process_time.xls')
      end


      20.times do
        result=RubyProf.profile do
          Category.root
        end

        printer = ExcelPrinter::FlatExcelPrinter.new(result)
        printer.print('tmp/report_get_roots_process_time.xls')
      end

      RubyProf.measure_mode = RubyProf::WALL_TIME

      20.times do
        result=RubyProf.profile do
          last_node.ancestors
        end


        printer = ExcelPrinter::FlatExcelPrinter.new(result)
        printer.print('tmp/report_read_ancestors_wall_time.xls')
      end


      20.times do
        result=RubyProf.profile do
          Category.root
        end

        printer = ExcelPrinter::FlatExcelPrinter.new(result)
        printer.print('tmp/report_get_roots_wall_time.xls')
      end
    end
  end
end
