require File.expand_path("#{File.dirname(__FILE__)}/test_helper")

class CommonMethodsTest < Test::Unit::TestCase
  include ActsAsSolr::CommonMethods
  
  class Mongo
    include MongoMapper::Document
    include ActsAsSolr::MongoMapper
    acts_as_solr
    
    def id
      '4b5e0119f3a4b02902000001'
    end
  end
  
  class << self
    def primary_key
      "id"
    end
  end
  
  def id
    10
  end
  
  context "when determining the field type" do
    setup do
    end
    
    should "return i for an integer" do
      assert_equal "i", get_solr_field_type(:integer)
    end
    
    should "return f for a float" do
      assert_equal "f", get_solr_field_type(:float)
    end
    
    should "return b for a boolean" do
      assert_equal "b", get_solr_field_type(:boolean)
    end
    
    should "return s for a string" do
      assert_equal "s", get_solr_field_type(:string)
    end
    
    should "return t for a text" do
      assert_equal "t", get_solr_field_type(:text)
    end
    
    should "return d for a date" do
      assert_equal "d", get_solr_field_type(:date)
    end
    
    should "return ri for a range_integer" do
      assert_equal "ri", get_solr_field_type(:range_integer)
    end
    
    should "return rf for a range_float" do
      assert_equal "rf", get_solr_field_type(:range_float)
    end
    
    should "return facet for a facet field" do
      assert_equal "facet", get_solr_field_type(:facet)
    end
    
    should "return the string if one was given as an argument" do
      assert_equal "string", get_solr_field_type("string")
    end
    
    should "raise an error if invalid field type was specified" do
      assert_raise(RuntimeError) {get_solr_field_type(:something)}
    end
    
    should "raise an error if argument is not symbol or string" do
      assert_raise(RuntimeError) {get_solr_field_type(123)}
    end
  end
  
  context "when determining a default value for a field when it's nil" do
    should "return 0.00 for a float" do
      assert_equal 0.00, set_value_if_nil("f")
      assert_equal 0.00, set_value_if_nil(:float)
      assert_equal 0.00, set_value_if_nil("rf")
      assert_equal 0.00, set_value_if_nil(:range_float)
    end
    
    should "return 0 for an integer" do
      assert_equal 0, set_value_if_nil(:integer)
      assert_equal 0, set_value_if_nil(:range_integer)
      assert_equal 0, set_value_if_nil("i")
      assert_equal 0, set_value_if_nil("ri")
    end
    
    should "return false for a boolean" do
      assert_equal "false", set_value_if_nil(:boolean)
      assert_equal "false", set_value_if_nil("b") 
    end
    
    should "return empty string for strings and text" do
      assert_equal "", set_value_if_nil(:string)
      assert_equal "", set_value_if_nil(:text)
      assert_equal "", set_value_if_nil("t")
      assert_equal "", set_value_if_nil("s")
    end
    
    should "return an empty string for a date" do
      assert_equal "", set_value_if_nil(:date)
      assert_equal "", set_value_if_nil("d")
    end
    
    should "return an empty string for everything else" do
      assert_equal "", set_value_if_nil("something")
    end
  end
  
  context "when determining the record id" do
    context "on ActiveRecord" do
      should "return the primary key value" do
        assert_equal 10, record_id(self)
      end
    end
    context "on MongoMapper" do
      should "return the id value" do
        assert_equal '4b5e0119f3a4b02902000001', record_id(Mongo.new)
      end
    end
  end
end