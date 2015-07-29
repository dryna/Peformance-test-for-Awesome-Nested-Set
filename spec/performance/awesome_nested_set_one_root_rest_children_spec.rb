require 'spec_helper'
require 'awesome_nested_set/helper'
require 'rspec-prof'
require 'support/rspec-prof'

require 'spreadsheet'
require 'support/flat_excel_printer'

describe "AwesomeNestedSet" do

  describe "process time" do
    before(:each) do
      RubyProf.measure_mode = RubyProf::PROCESS_TIME
      @test_nodes = []
      @n = 100000
      Category.delete_all
      (1..@n).to_a.each do |i|
        @test_nodes[i] = Category.create(id: i, name: "name#{i}")
        p i
      end
    end

    it "It takes time" do
      RubyProf.measure_mode = RubyProf::WALL_TIME
      result=RubyProf.profile do
        (2..@n).to_a.each do |i|
          @test_nodes[i].move_to_child_of(@test_nodes[1])
        end
      end



      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_add_ancestor_wall_time.xls')

      RubyProf.measure_mode = RubyProf::PROCESS_TIME

      20.times do
        result=RubyProf.profile do
          @test_nodes[@n].ancestors
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
          @test_nodes[@n].ancestors
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
