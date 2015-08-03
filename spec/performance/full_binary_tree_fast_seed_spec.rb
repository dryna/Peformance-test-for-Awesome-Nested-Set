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
      @n = 8191 #255 1023 8191 65535 131071 1048575
      Category.delete_all
      (1..@n).to_a.each do |i|
        @test_nodes[i]={lft: 0, rgt: 3*@n}
        p i
      end
      records =""
      records+="(#{1}, 'name#{1}',null,#{0},#{3*@n}),"
      z=2
      (1..((@n/2))).to_a.each do |i|
        dif = (@test_nodes[i][:rgt] - @test_nodes[i][:lft] - 3)/2 + 1
        records+="(#{z}, 'name#{z}',#{i},#{@test_nodes[i][:lft]+1},#{@test_nodes[i][:lft]+1+dif}),"
        @test_nodes[z][:lft] = @test_nodes[i][:lft]+1
        @test_nodes[z][:rgt]= @test_nodes[i][:lft]+1+dif
        records+="(#{z+1}, 'name#{z+1}',#{i},#{@test_nodes[z][:rgt]+1},#{@test_nodes[i][:rgt]-1}),"
        @test_nodes[z+1][:lft] = @test_nodes[z][:rgt]+1
        @test_nodes[z+1][:rgt] =@test_nodes[i][:rgt]-1
        z+=2
        p i
      end

      records=records.gsub(/,$/, '')
      ActiveRecord::Base.connection.execute("INSERT INTO categories (id, name, parent_id, lft, rgt) VALUES #{records}")
    end

    it "It takes time" do

      RubyProf.measure_mode = RubyProf::PROCESS_TIME
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
