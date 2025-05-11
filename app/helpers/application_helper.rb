module ApplicationHelper
    def tea_category_color(category)
        colors = {
          'Black' => 'dark',
          'Green' => 'success',
          'White' => 'light',
          'Oolong' => 'warning',
          'Herbal' => 'info',
          'Pu-erh' => 'danger',
          'Rooibos' => 'primary'
        }
        
        colors[category] || 'secondary'
      end
end
