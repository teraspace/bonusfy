module Query
  class PurchaseFilter
    def self.call(filters)
      scope = Purchase.includes(product: :category).all
      
      if filters[:units].present?
        scope = scope.by_units(filters[:units])
      end

      if filters[:amount].present?
        scope = scope.by_amount(filters[:amount])
      end

      if filters[:buyer].present?
        scope = scope.by_buyer(filters[:buyer])
      end

      if filters[:color].present?
        scope = scope.by_product_color(filters[:color])
      end

      if filters[:material].present?
        scope = scope.by_product_material(filters[:material])
      end

      if filters[:weight].present?
        scope = scope.by_product_weigth(filters[:weight])
      end

      if filters[:product].present?
        scope = scope.by_product(filters[:product])
      end

      if filters[:start_date].present?
        scope = scope.created_start(filters[:start_date])
      end

      if filters[:end_date].present?
        scope = scope.created_end(filters[:end_date])
      end
      
      if filters[:page].present?
        page = filters[:page]
        page ||=1
        per_page = filters[:per_page]
        per_page ||= 10
        scope = scope.paginate({ page: page, per_page: per_page })
      end

      scope
    end
  end
end