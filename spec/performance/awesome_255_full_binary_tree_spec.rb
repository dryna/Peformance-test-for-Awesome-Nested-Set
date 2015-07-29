require 'spec_helper'
require 'awesome_nested_set/helper'
require 'rspec-prof'
require 'support/rspec-prof'

require 'spreadsheet'
require 'support/flat_excel_printer'

describe "AwesomeNestedSet" do
  before(:all) do
    self.class.fixtures :departments, :notes, :things, :brokens, :users, :default_scoped_models
  end

  before(:each) do
    @n = 255
    @test_nodes = []
    z= 2
    @test_nodes[1] = Category.create(:name => 'Root1')
    (1..((@n/2)-1)).to_a.each do |i|
      @test_nodes[z]= @test_nodes[i].children.create(:name => "Root#{z}")
      @test_nodes[z+1]=@test_nodes[i].children.create(:name => "Root#{z+1}")
      z+=2
    end
  end

  describe "process time" do
    before(:each) do
      RubyProf.measure_mode = RubyProf::PROCESS_TIME
    end
    it "It takes time to build 255 nodes inline as_children" do
      @test_nodes = []
      Category.delete_all
      result=RubyProf.profile do
        z= 2
        @test_nodes[1] = Category.create(:name => 'Root1')
        (1..127).to_a.each do |i|
          @test_nodes[z]= @test_nodes[i].children.create(:name => "Root#{z}")
          @test_nodes[z+1]=@test_nodes[i].children.create(:name => "Root#{z+1}")
          z+=2
        end
      end
      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_add_ancestor.xls')

      z= 2
      (1..127).to_a.each do |i|
        expect(@test_nodes[z].parent_id).to eq @test_nodes[i].primary_id
        expect(@test_nodes[z+1].parent_id).to eq @test_nodes[i].primary_id
        z+=2
      end
    end

    it "It takes time to remove 255 nodes inline from bottom" do

      result=RubyProf.profile do
        (2..255).to_a.reverse.each do |i|
          @test_nodes[i].destroy
        end
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_remove_from_bottom.xls')

      @test_nodes[1].reload
      # printer.print(STDOUT, :min_percent => 3)
      expect(@test_nodes[1].children).to eq []
    end

    it "It takes time to read ancestors" do

      result=RubyProf.profile do
        @test_nodes[255].ancestors
      end


      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_read_ancestors.xls')

    end


    it "It takes time to get roots" do
      result=RubyProf.profile do
        Category.root
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_get_roots.xls')


      @test_nodes[1].reload
      expect(Category.root).to eq @test_nodes[1]
    end
  end

  describe "process time" do
    before(:each) do
      RubyProf.measure_mode = RubyProf::PROCESS_TIME
    end

    it "It takes time to build 255 nodes inline as_children" do
      @test_nodes = []
      Category.delete_all
      result=RubyProf.profile do
        z= 2
        @test_nodes[1] = Category.create(:name => 'Root1')
        (1..127).to_a.each do |i|
          @test_nodes[z]= @test_nodes[i].children.create(:name => "Root#{z}")
          @test_nodes[z+1]=@test_nodes[i].children.create(:name => "Root#{z+1}")
          z+=2
        end
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_add_ancestor_process_time.xls')


      z= 2
      (1..127).to_a.each do |i|
        expect(@test_nodes[z].parent_id).to eq @test_nodes[i].primary_id
        expect(@test_nodes[z+1].parent_id).to eq @test_nodes[i].primary_id
        z+=2
      end
    end

    it "It takes time to remove 255 nodes inline from bottom" do

      result=RubyProf.profile do
        (2..255).to_a.reverse.each do |i|
          @test_nodes[i].destroy
        end
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_remove_from_bottom_process_time.xls')

      @test_nodes[1].reload
      expect(@test_nodes[1].children).to eq []
    end

    it "It takes time to read ancestors" do

      result=RubyProf.profile do
        @test_nodes[255].ancestors
      end


      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_read_ancestors_process_time.xls')

    end


    it "It takes time to get roots" do

      result=RubyProf.profile do
        Category.root
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_get_roots_process_time.xls')


      @test_nodes[1].reload
      expect(Category.root).to eq @test_nodes[1]
    end
  end

  describe "cpu time" do
    before(:each) do
      RubyProf.measure_mode = RubyProf::CPU_TIME
    end
    it "It takes time to build 255 nodes inline as_children" do
      @test_nodes = []
      Category.delete_all
      result=RubyProf.profile do
        z= 2
        @test_nodes[1] = Category.create(:name => 'Root1')
        (1..127).to_a.each do |i|
          @test_nodes[z]= @test_nodes[i].children.create(:name => "Root#{z}")
          @test_nodes[z+1]=@test_nodes[i].children.create(:name => "Root#{z+1}")
          z+=2
        end
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_add_ancestor_cpu_time.xls')


      z= 2
      (1..127).to_a.each do |i|
        expect(@test_nodes[z].parent_id).to eq @test_nodes[i].primary_id
        expect(@test_nodes[z+1].parent_id).to eq @test_nodes[i].primary_id
        z+=2
      end
    end

    it "It takes time to remove 255 nodes inline from bottom" do

      result=RubyProf.profile do
        (2..255).to_a.reverse.each do |i|
          @test_nodes[i].destroy
        end
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_remove_from_bottom_cpu_time.xls')

      @test_nodes[1].reload
      # printer.print(STDOUT, :min_percent => 3)
      expect(@test_nodes[1].children).to eq []
    end

    it "It takes time to read ancestors" do

      result=RubyProf.profile do
        @test_nodes[255].ancestors
      end


      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_read_ancestors_cpu_time.xls')

    end


    it "It takes time to get roots" do

      result=RubyProf.profile do
        Category.root
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_get_roots_cpu_time.xls')

      @test_nodes[1].reload
      expect(Category.root).to eq @test_nodes[1]
    end
  end

  describe "allocations" do
    before(:each) do
      RubyProf.measure_mode = RubyProf::ALLOCATIONS
    end
    it "It takes time to build 255 nodes inline as_children" do
      @test_nodes = []
      Category.delete_all
      result=RubyProf.profile do
        z= 2
        @test_nodes[1] = Category.create(:name => 'Root1')
        (1..127).to_a.each do |i|
          @test_nodes[z]= @test_nodes[i].children.create(:name => "Root#{z}")
          @test_nodes[z+1]=@test_nodes[i].children.create(:name => "Root#{z+1}")
          z+=2
        end
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_add_ancestor_allocations.xls')


      z= 2
      (1..127).to_a.each do |i|
        expect(@test_nodes[z].parent_id).to eq @test_nodes[i].primary_id
        expect(@test_nodes[z+1].parent_id).to eq @test_nodes[i].primary_id
        z+=2
      end
    end

    it "It takes time to remove 255 nodes inline from bottom" do
      result=RubyProf.profile do
        (2..255).to_a.reverse.each do |i|
          @test_nodes[i].destroy
        end
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_remove_from_bottom_allocations.xls')

      @test_nodes[1].reload
      # printer.print(STDOUT, :min_percent => 3)
      expect(@test_nodes[1].children).to eq []
    end

    it "It takes time to read ancestors" do

      result=RubyProf.profile do
        @test_nodes[255].ancestors
      end


      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_read_ancestors_allocations.xls')

    end


    it "It takes time to get roots" do

      result=RubyProf.profile do
        Category.root
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_get_roots_allocations.xls')

      @test_nodes[1].reload
      expect(Category.root).to eq @test_nodes[1]
    end
  end

  describe "memory" do
    before(:each) do
      RubyProf.measure_mode = RubyProf::MEMORY
    end
    it "It takes time to build 255 nodes inline as_children" do
      @test_nodes = []
      Category.delete_all
      result=RubyProf.profile do
        z= 2
        @test_nodes[1] = Category.create(:name => 'Root1')
        (1..127).to_a.each do |i|
          @test_nodes[z]= @test_nodes[i].children.create(:name => "Root#{z}")
          @test_nodes[z+1]=@test_nodes[i].children.create(:name => "Root#{z+1}")
          z+=2
        end
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_add_ancestor_memory.xls')


      z= 2
      (1..127).to_a.each do |i|
        expect(@test_nodes[z].parent_id).to eq @test_nodes[i].primary_id
        expect(@test_nodes[z+1].parent_id).to eq @test_nodes[i].primary_id
        z+=2
      end
    end

    it "It takes time to remove 255 nodes inline from bottom" do

      result=RubyProf.profile do
        (2..255).to_a.reverse.each do |i|
          @test_nodes[i].destroy
        end
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_remove_from_bottom_memory.xls')

      @test_nodes[1].reload
      expect(@test_nodes[1].children).to eq []
    end

    it "It takes time to read ancestors" do

      result=RubyProf.profile do
        @test_nodes[255].ancestors
      end


      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_read_ancestors_memory.xls')

    end


    it "It takes time to get roots" do
      result=RubyProf.profile do
        Category.root
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_get_roots_memory.xls')

      @test_nodes[1].reload
      expect(Category.root).to eq @test_nodes[1]
    end
  end


end
