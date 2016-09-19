require 'rails_helper'

feature "Rails Upload App" do

  before :all do
    $continue = true
  end

  around :each do |example|
    if $continue
      $continue = false 
      example.run 
      $continue = true unless example.exception
    else
      example.skip
    end
  end

  #helper method to determine if Ruby class exists as a class
  def class_exists?(class_name)
    eval("defined?(#{class_name}) && #{class_name}.is_a?(Class)") == true
  end

  #helper method to determine if two files are the same
  def files_same?(file1, file2) 
    if (File.size(file1) != File.size(file2)) then
      return false
    end
    f1 = IO.readlines(file1)
    f2 = IO.readlines(file2)
    if ((f1 - f2).size == 0) then
      return true
    else
      return false
    end
  end

  context "rq01" do
    context "Generate Rails application" do
      it "must have top level structure of a rails application" do
        expect(File.exists?("Gemfile")).to be(true)
        expect(Dir.entries(".")).to include("app", "bin", "config", "db", "lib", "public", "log", "test", "vendor")
        expect(Dir.entries("./app")).to include("assets", "controllers", "helpers", "mailers", "models", "views")        
      end
    end
  end

  # check that Product exists with fields and migration/db exists
  context "rq02" do
    before :each do    
      Product.destroy_all
      load "#{Rails.root}/db/seeds.rb"  
    end

    context "Scaffolding generated" do
      it "must have at least one controller and views" do 
        expect(Dir.entries("./app/controllers")).to include("products_controller.rb")
        expect(Dir.entries("./app/views/")).to include("products")
        expect(Dir.entries("./app/views/products")).to include("import.html.erb")
        expect(Dir.entries("./app/views/products")).to include("upload.html.erb")
      end
    end
    context "Products Model" do
      it "Products class" do
        expect(class_exists?("Product"))
        expect(Product < ActiveRecord::Base).to eq(true)
      end
    end
    context "Product class properties added" do
      subject(:product) { Product.new }
      it { is_expected.to respond_to(:buyer) }
      it { is_expected.to respond_to(:description) }
      it { is_expected.to respond_to(:unit_price) }
      it { is_expected.to respond_to(:amount) }
      it { is_expected.to respond_to(:address) }
      it { is_expected.to respond_to(:provider) }
      it { is_expected.to respond_to(:created_at) } 
      it { is_expected.to respond_to(:updated_at) } 
    end
    it "Product database structure in place" do
      # rails g model todo_item due_date:date title description:text
      # rake db:migrate
      expect(Product.column_names).to include "buyer", "description", "unit_price", "amount", "address", "provider"
      expect(Product.column_types["buyer"].type).to eq :string
      expect(Product.column_types["description"].type).to eq :string
      expect(Product.column_types["unit_price"].type).to eq :decimal
      expect(Product.column_types["amount"].type).to eq :integer
      expect(Product.column_types["address"].type).to eq :string
      expect(Product.column_types["provider"].type).to eq :string
      expect(Product.column_types["created_at"].type).to eq :datetime
      expect(Product.column_types["updated_at"].type).to eq :datetime
    end
  end

  context "rq03" do 
    before :each do    
      Product.destroy_all
      load "#{Rails.root}/db/seeds.rb"  
    end

    # Check that database has been initialized with seed file prior to test
    it "has the file that seeded the database" do
      expect(File).to exist("#{Rails.root}/db/seeds.rb")
    end
    it "must have Product as provided by seed file" do
      expect(Product.all.length).to eq(4)
      expect(Product.all.map{ |x| x.buyer }).to include("João Silva", "Amy Pond", "Marty McFly", "Snake Plissken")
    end
  end

  context "rq04" do 
    before :each do
      Product.destroy_all
      load "#{Rails.root}/db/seeds.rb"  
    end

    scenario "products import URI should return a valid page" do
      visit products_import_path
      expect(page.status_code).to eq(200)
    end
  end

  context "rq05" do
    before :each do    
      Product.destroy_all
      extend ActionDispatch::TestProcess
      @file = fixture_file_upload('files/dados.txt', 'text/txt')
    end

    context "Checking uploaded file" do
      it "must have at least one dados.txt" do
        expect(Dir.entries("./public/import")).to include("dados.txt")
      end
    end
  end
end
