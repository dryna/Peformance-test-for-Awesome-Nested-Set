require 'spec_helper'
require 'awesome_nested_set/helper'
require 'rspec-prof'
require 'support/rspec-prof'

require 'spreadsheet'
require 'support/flat_excel_printer'
require 'support/customize_flat_excel_printer'

describe "AwesomeNestedSet" do

  describe "process time" do

    it "It takes time to build nodes inline" do
      [200, 1000, 10000].each do |tempN|#200, 1000, 10000, 100000


        Category.delete_all
        @n = tempN
        left = 0
        right = 2*@n+1
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

        name = @n.to_s + ' nodes in line ' +'read_ancestors_process_time'
        last_node = Category.find_by_id(@n)
        10.times do
          result=RubyProf.profile do
            last_node.ancestors.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' nodes in line ' +'get_roots_process_time'
        10.times do
          result=RubyProf.profile do
            Category.root.inspect
          end

          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end
        first_node = Category.find_by_id(1)
        name = @n.to_s + ' nodes in line ' +'read_descendants_process_time'
        10.times do
          result=RubyProf.profile do
            first_node.descendants.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end
        middle_node = Category.find_by_id(@n/2)
        name = @n.to_s + ' nodes in line ' +'read_ancestors_from_middle_process_time'
        10.times do
          result=RubyProf.profile do
            middle_node.ancestors.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' nodes in line ' +'read_descendants_from_middle_process_time'
        10.times do
          result=RubyProf.profile do
            middle_node.descendants.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' nodes in line ' +'tree_roots_process_time'
        10.times do
          result=RubyProf.profile do
            Category.each_with_level(Category.root.self_and_descendants) do |o, level|
              t = {node: o, level: level}
            end
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' nodes in line ' +'remove_from_bottom_process_time'
        10.times do
          #get last node
          result=RubyProf.profile do
            last_node.destroy
          end
          Category.last.children.create(id: @n, name: "name#{@n}")
          last_node = Category.find_by_id(@n)


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end


        RubyProf.measure_mode = RubyProf::WALL_TIME

        name = @n.to_s + ' nodes in line ' +'read_ancestors_wall_time'
        10.times do
          result=RubyProf.profile do
            last_node.ancestors.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' nodes in line ' +'get_roots_wall_time'
        10.times do
          result=RubyProf.profile do
            Category.root.inspect
          end

          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end
        first_node = Category.find_by_id(1)
        name = @n.to_s + ' nodes in line ' +'read_descendants_wall_time'
        10.times do
          result=RubyProf.profile do
            first_node.descendants.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end
        middle_node = Category.find_by_id(@n/2)
        name = @n.to_s + ' nodes in line ' +'read_ancestors_from_middle_wall_time'
        10.times do
          result=RubyProf.profile do
            middle_node.ancestors.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' nodes in line ' +'read_descendants_from_middle_wall_time'
        10.times do
          result=RubyProf.profile do
            middle_node.descendants.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' nodes in line ' +'tree_roots_wall_time'
        10.times do
          result=RubyProf.profile do
            Category.each_with_level(Category.root.self_and_descendants) do |o, level|
              t = {node: o, level: level}
            end
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' nodes in line ' +'remove_from_bottom_wall_time'
        10.times do
          #get last node
          result=RubyProf.profile do
            last_node.destroy
          end
          Category.last.children.create(id: @n, name: "name#{@n}")
          last_node = Category.find_by_id(@n)


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

      end



    end

    it "It takes time to build one root rest children" do
      [200, 1000, 10000, 100000].each do |tempN|#200, 1000, 10000, 100000


        Category.delete_all
        @n = tempN
        left = 0
        records =""
        records+="(#{1}, 'name#{1}',null,#{left},#{@n+2}),"
        left+=1
        (2..@n).to_a.each do |i|
          records+="(#{i}, 'name#{i}',#{1},#{left},#{left+1}),"
          left+=1
          p i
        end

        records=records.gsub(/,$/, '')
        ActiveRecord::Base.connection.execute("INSERT INTO categories (id, name, parent_id, lft, rgt) VALUES #{records}")

        name = @n.to_s + ' one root rest children ' +'read_ancestors_process_time'
        last_node = Category.find_by_id(@n)
        10.times do
          result=RubyProf.profile do
            last_node.ancestors.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' one root rest children ' +'get_roots_process_time'
        10.times do
          result=RubyProf.profile do
            Category.root.inspect
          end

          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end
        first_node = Category.find_by_id(1)
        name = @n.to_s + ' one root rest children ' +'read_descendants_process_time'
        10.times do
          result=RubyProf.profile do
            first_node.descendants.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end
        middle_node = Category.find_by_id(@n/2)
        name = @n.to_s + ' one root rest children ' +'read_ancestors_from_middle_process_time'
        10.times do
          result=RubyProf.profile do
            middle_node.ancestors.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' one root rest children ' +'read_descendants_from_middle_process_time'
        10.times do
          result=RubyProf.profile do
            middle_node.descendants.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' one root rest children ' +'tree_roots_process_time'
        10.times do
          result=RubyProf.profile do
            Category.each_with_level(Category.root.self_and_descendants) do |o, level|
              t = {node: o, level: level}
            end
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' one root rest children ' +'remove_from_bottom_process_time'
        10.times do
          #get last node
          result=RubyProf.profile do
            last_node.destroy
          end
          Category.find_by_id(1).children.create(id: @n, name: "name#{@n}")
          last_node = Category.find_by_id(@n)


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end


        RubyProf.measure_mode = RubyProf::WALL_TIME

        name = @n.to_s + ' one root rest children ' +'read_ancestors_wall_time'
        10.times do
          result=RubyProf.profile do
            last_node.ancestors.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' one root rest children ' +'get_roots_wall_time'
        10.times do
          result=RubyProf.profile do
            Category.root.inspect
          end

          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end
        first_node = Category.find_by_id(1)
        name = @n.to_s + ' one root rest children ' +'read_descendants_wall_time'
        10.times do
          result=RubyProf.profile do
            first_node.descendants.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end
        middle_node = Category.find_by_id(@n/2)
        name = @n.to_s + ' one root rest children ' +'read_ancestors_from_middle_wall_time'
        10.times do
          result=RubyProf.profile do
            middle_node.ancestors.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' one root rest children ' +'read_descendants_from_middle_wall_time'
        10.times do
          result=RubyProf.profile do
            middle_node.descendants.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' one root rest children ' +'tree_roots_wall_time'
        10.times do
          result=RubyProf.profile do
            Category.each_with_level(Category.root.self_and_descendants) do |o, level|
              t = {node: o, level: level}
            end
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' one root rest children ' +'remove_from_bottom_wall_time'
        10.times do
          #get last node
          result=RubyProf.profile do
            last_node.destroy
          end
          Category.find_by_id(1).children.create(id: @n, name: "name#{@n}")
          last_node = Category.find_by_id(@n)


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

      end



    end

    it "It takes time to build full binary tree" do
      [255, 1023, 8191].each do |tempN| #255, 1023, 8191, 65535, 131071, 1048575


        @test_nodes = []
        @n = tempN
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

        name = @n.to_s + ' full binary tree ' +'read_ancestors_process_time'
        last_node = Category.find_by_id(@n)
        10.times do
          result=RubyProf.profile do
            last_node.ancestors.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' full binary tree ' +'get_roots_process_time'
        10.times do
          result=RubyProf.profile do
            Category.root.inspect
          end

          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end
        first_node = Category.find_by_id(1)
        name = @n.to_s + ' full binary tree ' +'read_descendants_process_time'
        10.times do
          result=RubyProf.profile do
            first_node.descendants.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end
        middle_node = Category.find_by_id(@n/2)
        name = @n.to_s + ' full binary tree ' +'read_ancestors_from_middle_process_time'
        10.times do
          result=RubyProf.profile do
            middle_node.ancestors.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' full binary tree ' +'read_descendants_from_middle_process_time'
        10.times do
          result=RubyProf.profile do
            middle_node.descendants.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' full binary tree ' +'tree_roots_process_time'
        10.times do
          result=RubyProf.profile do
            Category.each_with_level(Category.root.self_and_descendants) do |o, level|
              t = {node: o, level: level}
            end
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' full binary tree ' +'remove_from_bottom_process_time'
        10.times do
          #get last node
          result=RubyProf.profile do
            last_node.destroy
          end
          Category.find_by_id(@n/2).children.create(id: @n, name: "name#{@n}")
          last_node = Category.find_by_id(@n)

          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end


        RubyProf.measure_mode = RubyProf::WALL_TIME

        name = @n.to_s + ' full binary tree ' +'read_ancestors_wall_time'
        10.times do
          result=RubyProf.profile do
            last_node.ancestors.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' full binary tree ' +'get_roots_wall_time'
        10.times do
          result=RubyProf.profile do
            Category.root.inspect
          end

          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end
        first_node = Category.find_by_id(1)
        name = @n.to_s + ' full binary tree ' +'read_descendants_wall_time'
        10.times do
          result=RubyProf.profile do
            first_node.descendants.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end
        middle_node = Category.find_by_id(@n/2)
        name = @n.to_s + ' full binary tree ' +'read_ancestors_from_middle_wall_time'
        10.times do
          result=RubyProf.profile do
            middle_node.ancestors.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' full binary tree ' +'read_descendants_from_middle_wall_time'
        10.times do
          result=RubyProf.profile do
            middle_node.descendants.inspect
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' full binary tree ' +'tree_roots_wall_time'
        10.times do
          result=RubyProf.profile do
            Category.each_with_level(Category.root.self_and_descendants) do |o, level|
              t = {node: o, level: level}
            end
          end


          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

        name = @n.to_s + ' full binary tree ' +'remove_from_bottom_wall_time'
        10.times do
          #get last node
          result=RubyProf.profile do
            last_node.destroy
          end
          Category.find_by_id(@n/2).children.create(id: @n, name: "name#{@n}")
          last_node = Category.find_by_id(@n)

          printer = ExcelPrinter::CustomizeFlatExcelPrinter.new(result)
          printer.print('tmp/report_awesome_total_test.xls',name)
          name = 'false'
        end

      end
    end
  end
end
