require 'spec_helper'
require 'awesome_nested_set/helper'
require 'rspec-prof'
require 'csv'
require 'support/rspec-prof'

describe "AwesomeNestedSet" do

  def print(title, data)
    file_path = 'tmp/performance_test_ans.csv'
    CSV.open(file_path, 'ab') do |csv|
      csv << [title]
      data.each do |new_data|
        new_data.threads.each do |thread|
          csv << [thread.methods.sort.last.total_time]
        end
      end
    end
  end

  @nodes_in_line_counters = [10, 20]
  @one_root_rest_children_counters = [10]
  @binary_tree_counters = [15]

  @nodes_in_line_counters.each do |counter|
    describe 'Nodes in line:' do
      before(:all) do
        Category.delete_all
        @graph_size = counter
        @results = []
        left = 0
        right = 2 * @graph_size + 1
        records =""
        records += "(#{1}, 'name#{1}',null,#{left},#{right}),"
        left += 1
        right -= 1
        (2..@graph_size).each do |i|
          records += "(#{i}, 'name#{i}',#{i-1},#{left},#{right}),"
          left += 1
          right -= 1
        end
        records=records.gsub(/,$/, '')
        ActiveRecord::Base.connection.execute("INSERT INTO categories (id, name, parent_id, lft, rgt) VALUES #{records}")
        RubyProf.measure_mode = RubyProf::WALL_TIME
        last_node = Category.find_by_id(@graph_size)
      end

      after(:each) do
        print(@name, @results)
        @results.clear
      end

      it 'Add descendants' do
        p "adding descendants for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
      end

      it 'Read ancestors' do
        p "reading ancestors for #{@graph_size}..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        last_node = Category.find_by_id(@graph_size)
        10.times do
          result = RubyProf.profile do
            last_node.ancestors.inspect
          end
          @results << result
        end
      end

      it 'Get roots' do
        p "getting roots for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        10.times do
          result = RubyProf.profile do
            Category.root.inspect
          end
          @results << result
        end
      end

      it 'Read descendants' do
        p "reading descendants for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        first_node = Category.find_by_id(1)
        10.times do
          result = RubyProf.profile do
            first_node.descendants.inspect
          end
          @results << result
        end
      end

      it 'Read ancestors from middle' do
        p "reading ancestors from middle (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        middle_node = Category.find_by_id(@graph_size/2)
        10.times do
          result = RubyProf.profile do
            middle_node.ancestors.inspect
          end
          @results << result
        end
      end

      it 'Read descendants from middle' do
        p "reading descendants from middle (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        middle_node = Category.find_by_id(@graph_size/2)
        10.times do
          result = RubyProf.profile do
            middle_node.descendants.inspect
          end
          @results << result
        end
      end

      it 'Get tree roots' do
        p "getting tree roots for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        10.times do
          result = RubyProf.profile do
            Category.each_with_level(Category.root.self_and_descendants) do |o, level|
              t = {node: o, level: level}
            end
          end
          @results << result
        end
      end

      it 'Remove from bottom' do
        p "removing from bottom for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        last_node = Category.find_by_id(@graph_size)
        10.times do
          result = RubyProf.profile do
            last_node.destroy
          end
          Category.last.children.create(id: @graph_size, name: "name#{@graph_size}")
          last_node = Category.find_by_id(@graph_size)
          @results << result
        end
      end

    end
  end

  @one_root_rest_children_counters.each do |counter|
    describe 'One root rest children:' do
      before(:all) do
        Category.delete_all
        @results = []
        @graph_size = counter
        left = 0
        records = ""
        records += "(#{1}, 'name#{1}',null,#{left},#{@graph_size + 2}),"
        left += 1
        (2..@graph_size).each do |i|
          records += "(#{i}, 'name#{i}',#{1},#{left},#{left + 1}),"
          left += 1
        end

        records=records.gsub(/,$/, '')
        ActiveRecord::Base.connection.execute("INSERT INTO categories (id, name, parent_id, lft, rgt) VALUES #{records}")
        RubyProf.measure_mode = RubyProf::WALL_TIME
      end

      after(:each) do
        print(@name, @results)
        @results.clear
      end

      it 'Add descendants' do
        p "adding descendants for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
      end

      it 'Read ancestors' do
        p "reading ancestors for #{@graph_size}..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        last_node = Category.find_by_id(@graph_size)
        10.times do
          result = RubyProf.profile do
            last_node.ancestors.inspect
          end
          @results << result
        end
      end

      it 'Get roots' do
        p "getting roots for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        10.times do
          result = RubyProf.profile do
            Category.root.inspect
          end
          @results << result
        end
      end

      it 'Read descendants' do
        p "reading descendants for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        first_node = Category.find_by_id(1)
        10.times do
          result = RubyProf.profile do
            first_node.descendants.inspect
          end
          @results << result
        end
      end

      it 'Read ancestors from middle' do
        p "reading ancestors from middle (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        middle_node = Category.find_by_id(@graph_size/2)
        10.times do
          result = RubyProf.profile do
            middle_node.ancestors.inspect
          end
          @results << result
        end
      end

      it 'Read descendants from middle' do
        p "reading descendants from middle (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        middle_node = Category.find_by_id(@graph_size/2)
        10.times do
          result = RubyProf.profile do
            middle_node.descendants.inspect
          end
          @results << result
        end
      end

      it 'Get tree roots' do
        p "getting tree roots for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        10.times do
          result = RubyProf.profile do
            Category.each_with_level(Category.root.self_and_descendants) do |o, level|
              t = {node: o, level: level}
            end
          end
          @results << result
        end
      end

      it 'Remove from bottom' do
        p "removing from bottom for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        last_node = Category.find_by_id(@graph_size)
        10.times do
          result = RubyProf.profile do
            last_node.destroy
          end
          Category.find_by_id(1).children.create(id: @graph_size, name: "name#{@graph_size}")
          last_node = Category.find_by_id(@graph_size)
          @results << result
        end
      end
    end
  end

  @binary_tree_counters.each do |counter|
    describe 'Binary tree:' do
      before(:all) do
        @results = []
        Category.delete_all

        @test_nodes = []
        @graph_size = counter
        (1..@graph_size).each do |i|
          @test_nodes[i]={lft: 0, rgt: 3 * @graph_size}
        end
        records =""
        records+="(#{1}, 'name#{1}',null,#{0},#{3 * @graph_size}),"
        z=2
        (1..(@graph_size / 2)).each do |i|
          dif = (@test_nodes[i][:rgt] - @test_nodes[i][:lft] - 3)/2 + 1
          records+="(#{z}, 'name#{z}',#{i},#{@test_nodes[i][:lft] + 1},#{@test_nodes[i][:lft] + 1 + dif}),"
          @test_nodes[z][:lft] = @test_nodes[i][:lft] + 1
          @test_nodes[z][:rgt]= @test_nodes[i][:lft] + 1 + dif
          records+="(#{z + 1}, 'name#{z + 1}',#{i},#{@test_nodes[z][:rgt] + 1},#{@test_nodes[i][:rgt] - 1}),"
          @test_nodes[z + 1][:lft] = @test_nodes[z][:rgt] + 1
          @test_nodes[z + 1][:rgt] =@test_nodes[i][:rgt] - 1
          z+=2
        end
        records=records.gsub(/,$/, '')
        ActiveRecord::Base.connection.execute("INSERT INTO categories (id, name, parent_id, lft, rgt) VALUES #{records}")
        RubyProf.measure_mode = RubyProf::WALL_TIME
      end

      after(:each) do
        print(@name, @results)
        @results.clear
      end

      it 'Add descendants' do
        p "adding descendants for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
      end

      it 'Read ancestors' do
        p "reading ancestors for #{@graph_size}..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        last_node = Category.find_by_id(@graph_size)
        10.times do
          result = RubyProf.profile do
            last_node.ancestors.inspect
          end
          @results << result
        end
      end

      it 'Get roots' do
        p "getting roots for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        10.times do
          result = RubyProf.profile do
            Category.root.inspect
          end
          @results << result
        end
      end

      it 'Read descendants' do
        p "reading descendants for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        first_node = Category.find_by_id(1)
        10.times do
          result = RubyProf.profile do
            first_node.descendants.inspect
          end
          @results << result
        end
      end

      it 'Read ancestors from middle' do
        p "reading ancestors from middle (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        middle_node = Category.find_by_id(@graph_size/2)
        10.times do
          result = RubyProf.profile do
            middle_node.ancestors.inspect
          end
          @results << result
        end
      end

      it 'Read descendants from middle' do
        p "reading descendants from middle (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        middle_node = Category.find_by_id(@graph_size/2)
        10.times do
          result = RubyProf.profile do
            middle_node.descendants.inspect
          end
          @results << result
        end
      end

      it 'Get tree roots' do
        p "getting tree roots for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        10.times do
          result  =RubyProf.profile do
            Category.each_with_level(Category.root.self_and_descendants) do |o, level|
              t = {node: o, level: level}
            end
          end
          @results << result
        end
      end

      it 'Remove from bottom' do
        p "removing from bottom for (#{@graph_size})..."
        @name = self.class.description + RSpec.current_example.description + '(' + @graph_size.to_s + ')'
        last_node = Category.find_by_id(@graph_size)
        10.times do
          result = RubyProf.profile do
            last_node.destroy
          end
          Category.find_by_id(@graph_size/2).children.create(id: @graph_size, name: "name#{@graph_size}")
          last_node = Category.find_by_id(@graph_size)
          @results << result
        end
      end

    end
  end

end
