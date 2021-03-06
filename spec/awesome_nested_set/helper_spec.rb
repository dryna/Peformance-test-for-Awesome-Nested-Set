require 'spec_helper'
require 'awesome_nested_set/helper'
require 'rspec-prof'
require 'support/rspec-prof'

describe "Helper" do
  include CollectiveIdea::Acts::NestedSet::Helper

  before(:all) do
    self.class.fixtures :categories
  end

  describe "nested_set_options" do
    it "test_nested_set_options" do
      expected = [
        [" Top Level", 1],
        ["- Child 1", 2],
        ['- Child 2', 3],
        ['-- Child 2.1', 4],
        ['- Child 3', 5],
        [" Top Level 2", 6]
      ]
      actual = nested_set_options(Category.all) do |c|
        "#{'-' * c.level} #{c.name}"
      end
      expect(actual).to eq(expected)
    end

    it "test_nested_set_options_with_mover" do
      expected = [
        [" Top Level", 1],
        ["- Child 1", 2],
        ['- Child 3', 5],
        [" Top Level 2", 6]
      ]
      actual = nested_set_options(Category.all, categories(:child_2)) do |c|
        "#{'-' * c.level} #{c.name}"
      end
      expect(actual).to eq(expected)
    end

    it "test_nested_set_options_with_class_as_argument" do
      expected = [
        [" Top Level", 1],
        ["- Child 1", 2],
        ['- Child 2', 3],
        ['-- Child 2.1', 4],
        ['- Child 3', 5],
        [" Top Level 2", 6]
      ]
      actual = nested_set_options(Category) do |c|
        "#{'-' * c.level} #{c.name}"
      end
      expect(actual).to eq(expected)
    end

    it "test_nested_set_options_with_class_as_argument_with_mover" do
      expected = [
        [" Top Level", 1],
        ["- Child 1", 2],
        ['- Child 3', 5],
        [" Top Level 2", 6]
      ]
      actual = nested_set_options(Category, categories(:child_2)) do |c|
        "#{'-' * c.level} #{c.name}"
      end
      expect(actual).to eq(expected)
    end

    it "test_nested_set_options_with_array_as_argument_without_mover" do
      expected = [
        [" Top Level", 1],
        ["- Child 1", 2],
        ['- Child 2', 3],
        ['-- Child 2.1', 4],
        ['- Child 3', 5],
        [" Top Level 2", 6]
      ]
      actual = nested_set_options(Category.all) do |c|
        "#{'-' * c.level} #{c.name}"
      end
      expect(actual.length).to eq(expected.length)
      expected.flatten.each do |node|
        expect(actual.flatten).to include(node)
      end
    end

    it "test_nested_set_options_with_array_as_argument_with_mover" do
      expected = [
        [" Top Level", 1],
        ["- Child 1", 2],
        ['- Child 3', 5],
        [" Top Level 2", 6]
      ]
      actual = nested_set_options(Category.all, categories(:child_2)) do |c|
        "#{'-' * c.level} #{c.name}"
      end
      expect(actual.length).to eq(expected.length)
      expected.flatten.each do |node|
        expect(actual.flatten).to include(node)
      end
    end
  end
end
