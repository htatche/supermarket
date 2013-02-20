require 'json'

class Catalog
    attr_accessor :products

    def initialize (file)
        @file = file
        @products = JSON.parse(File.read(@file))
    end

    def get_product code
        @products.select do |product|
          product['code'] == code
        end.first
    end
end
