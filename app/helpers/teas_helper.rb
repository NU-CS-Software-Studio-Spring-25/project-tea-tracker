module TeasHelper
    class RankComparator
        def initialize(tea, category_teas, field = "rank")
          @tea = tea
          @category_teas = category_teas
          @field = field
        end
      
        def compare
        return "Comparison unavailable" if @category_teas.nil? || @category_teas.empty?
          selected = @category_teas.pluck(@field)
          category_average = selected.sum.to_f / selected.size
          tea_value = @tea.send(@field)
      
          if tea_value > category_average
            (tea_value - category_average).round(2).to_s + " better than"
          elsif tea_value < category_average
            (category_average - tea_value).round(2).to_s + " worse than"
          else
            "the same as"
          end
        end
    end

end
