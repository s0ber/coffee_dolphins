module MenuHelper
  def menu_items
    [
      ['Букмейкеры', bookmakers_path, menu_item_id: 'bookmakers'],
      ['Позиции', positions_path, menu_item_id: 'positions'],
      ['Категории', categories_path, menu_item_id: 'categories'],
      ['Лендинги', landings_path, menu_item_id: 'landings'],
      ['Статистика', statistics_path, menu_item_id: 'statistics'],
      ['Финансы', finances_path, menu_item_id: 'finances'],
      ['Пользователи', users_path, menu_item_id: 'users']
    ]
  end
end
