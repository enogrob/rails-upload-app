class ProductsController < ApplicationController
  # POST /products/import
  def import
  end

  # POST /products/upload
  def upload
    name = params[:import][:file].original_filename
    directory = "public/import"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(params[:import][:file].read) }
    flash[:notice] = "File uploaded !"
    File.open(path, "r") do |f|
      @lines = f.readlines
    end
    @lines.shift #remove first line
    @lines.each do |line|
      line = line.split("\t")
      Product.create(
          buyer: line[0],
          description: line[1],
          unit_price: line[2].to_f,
          amount: line[3].to_i,
          address: line[4],
          provider: line[5])
    end

    @products = Product.all
  end
end
