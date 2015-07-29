require 'spec_helper'
require 'awesome_nested_set/helper'
require 'rspec-prof'
require 'support/rspec-prof'

require 'spreadsheet'
require 'support/flat_excel_printer'

describe "AwesomeNestedSet" do
  before(:all) do
    self.class.fixtures :categories, :departments, :notes, :things, :brokens, :users, :default_scoped_models
  end

  describe "wall time" do
    it "It takes time to build 200 nodes inline as_children" do
      @test_nodes = []
      result=RubyProf.profile do
        @test_nodes[1] = Category.create(:name => 'Root1')
        (2..200).to_a.each do |i|
          @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
        end
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_add_ancestor.xls')


      (2..200).to_a.each do |i|
        expect(@test_nodes[i].parent_id).to eq @test_nodes[i-1].primary_id
      end
    end

    it "It takes time to remove 200 nodes inline from bottom" do
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

        result=RubyProf.profile do
          (2..200).to_a.reverse.each do |i|
            @test_nodes[i].destroy
          end
        end
      # printer = RubyProf::GraphHtmlPrinter.new(result)
      # # File.open("tmp/profile_data.html", 'w') { |file| printer.print(file)}
      # # printer = RubyProf::FlatPrinterWithLineNumbers.new(result)
      # File.open("tmp/html_data_200_node_inline_remove.html", 'w') { |file| printer.print(file)}

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_remove_from_bottom.xls')

      @test_nodes[1].reload
      # printer.print(STDOUT, :min_percent => 3)
      expect(@test_nodes[1].children).to eq []
    end

    it "It takes time to read ancestors" do
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

      result=RubyProf.profile do
        @test_nodes[200].ancestors
      end
      # printer = RubyProf::GraphHtmlPrinter.new(result)
      # # File.open("tmp/profile_data.html", 'w') { |file| printer.print(file)}
      # # printer = RubyProf::FlatPrinterWithLineNumbers.new(result)
      # File.open("tmp/html_data_200_node_inline_node[200]_ancestors.html", 'w') { |file| printer.print(file)}
      # # printer.print(STDOUT, :min_percent => 3)


      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_read_ancestors.xls')

    end


    it "It takes time to get roots" do
      Category.delete_all
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

      result=RubyProf.profile do
        Category.root
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_get_roots.xls')


      # printer = RubyProf::GraphHtmlPrinter.new(result)
      # # File.open("tmp/profile_data.html", 'w') { |file| printer.print(file)}
      # # printer = RubyProf::FlatPrinterWithLineNumbers.new(result)
      # File.open("tmp/html_data_200_node_inline_roots.html", 'w') { |file| printer.print(file)}
      # printer.print(STDOUT, :min_percent => 3)
      @test_nodes[1].reload
      expect(Category.root).to eq @test_nodes[1]
    end
  end

  describe "process time" do
    before(:each) do
      RubyProf.measure_mode = RubyProf::PROCESS_TIME
    end

    it "It takes time to build 200 nodes inline as_children" do
      @test_nodes = []
      # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
      result=RubyProf.profile do
        @test_nodes[1] = Category.create(:name => 'Root1')
        (2..200).to_a.each do |i|
          @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
        end
      end


      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_add_ancestor_process_time.xls')


      (2..200).to_a.each do |i|
        expect(@test_nodes[i].parent_id).to eq @test_nodes[i-1].primary_id
      end
    end

    it "It takes time to remove 200 nodes inline from bottom" do
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

      result=RubyProf.profile do
        (2..200).to_a.reverse.each do |i|
          @test_nodes[i].destroy
        end
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_remove_from_bottom_process_time.xls')

      @test_nodes[1].reload
      # printer.print(STDOUT, :min_percent => 3)
      expect(@test_nodes[1].children).to eq []
    end

    it "It takes time to read ancestors" do
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

      result=RubyProf.profile do
        @test_nodes[200].ancestors
      end


      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_read_ancestors_process_time.xls')

    end


    it "It takes time to get roots" do
      Category.delete_all
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

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
    it "It takes time to build 200 nodes inline as_children" do
      @test_nodes = []
      # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
      result=RubyProf.profile do
        @test_nodes[1] = Category.create(:name => 'Root1')
        (2..200).to_a.each do |i|
          @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
        end
      end


      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_add_ancestor_cpu_time.xls')


      (2..200).to_a.each do |i|
        expect(@test_nodes[i].parent_id).to eq @test_nodes[i-1].primary_id
      end
    end

    it "It takes time to remove 200 nodes inline from bottom" do
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

      result=RubyProf.profile do
        (2..200).to_a.reverse.each do |i|
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
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

      result=RubyProf.profile do
        @test_nodes[200].ancestors
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_read_ancestors_cpu_time.xls')

    end


    it "It takes time to get roots" do
      Category.delete_all
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

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
    it "It takes time to build 200 nodes inline as_children" do
      @test_nodes = []
      # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
      result=RubyProf.profile do
        @test_nodes[1] = Category.create(:name => 'Root1')
        (2..200).to_a.each do |i|
          @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
        end
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_add_ancestor_allocations.xls')


      (2..200).to_a.each do |i|
        expect(@test_nodes[i].parent_id).to eq @test_nodes[i-1].primary_id
      end
    end

    it "It takes time to remove 200 nodes inline from bottom" do
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

      result=RubyProf.profile do
        (2..200).to_a.reverse.each do |i|
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
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

      result=RubyProf.profile do
        @test_nodes[200].ancestors
      end


      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_read_ancestors_allocations.xls')

    end


    it "It takes time to get roots" do
      Category.delete_all
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

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
    it "It takes time to build 200 nodes inline as_children" do
      @test_nodes = []
      # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
      result=RubyProf.profile do
        @test_nodes[1] = Category.create(:name => 'Root1')
        (2..200).to_a.each do |i|
          @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
        end
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_add_ancestor_memory.xls')


      (2..200).to_a.each do |i|
        expect(@test_nodes[i].parent_id).to eq @test_nodes[i-1].primary_id
      end
    end

    it "It takes time to remove 200 nodes inline from bottom" do
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

      result=RubyProf.profile do
        (2..200).to_a.reverse.each do |i|
          @test_nodes[i].destroy
        end
      end

      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_remove_from_bottom_memory.xls')

      @test_nodes[1].reload
      expect(@test_nodes[1].children).to eq []
    end

    it "It takes time to read ancestors" do
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

      result=RubyProf.profile do
        @test_nodes[200].ancestors
      end


      printer = ExcelPrinter::FlatExcelPrinter.new(result)
      printer.print('tmp/report_read_ancestors_memory.xls')

    end


    it "It takes time to get roots" do
      Category.delete_all
      @test_nodes =[]
      @test_nodes[1] = Category.create(:name => 'Root1')
      (2..200).to_a.each do |i|
        @test_nodes[i] = @test_nodes[i-1].children.create(:name => "Root#{i}")
      end

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
