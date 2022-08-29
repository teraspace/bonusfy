module Query
  class PurchaseRanking

    def initialize(top)
      @top = top
    end

    def run
      ActiveRecord::Base.connection.exec_query(top_n_by_category).to_a
    end

    def top_n_by_category
     " 
        SELECT category_name, product_name, sales
        FROM (
          #{rankings_sales.to_sql}
        ) t
        WHERE top_counter <= #{@top}
        ORDER BY category_name;
      "
    end

    def rankings_sales
      total_sales.group('products_sales.id, products_sales.product')
      .select(
             'products_sales.id product_id, 
              products_sales.product product_name,
              MAX(category) category_name, 
              SUM(purchases.units) sales,
              ROW_NUMBER() OVER (PARTITION BY MAX(category) ORDER BY SUM(purchases.units) DESC) top_counter'
            )
    end

    def products_sales
      Product.joins(:category, :purchases)
      .select('products.id, categories.name as category, products.name as product, purchases.units as sales')
    end

    def total_sales
      Purchase.joins("INNER JOIN (#{products_sales.to_sql}) products_sales ON products_sales.id = purchases.product_id")
    end

  end
end