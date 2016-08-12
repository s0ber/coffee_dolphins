module MenuHelper
  def menu_items
    [
      ['Букмейкеры', bookmakers_path, menu_item_id: 'bookmakers'],
      ['Линии ставок', bet_lines_path, menu_item_id: 'bet_lines'],
      ['Активные вилки', forks_path, menu_item_id: 'forks'],
      ['Позиции', positions_path, menu_item_id: 'positions'],
      ['Категории', categories_path, menu_item_id: 'categories'],
      ['Лендинги', landings_path, menu_item_id: 'landings'],
      ['Пользователи', users_path, menu_item_id: 'users']
    ]
  end

  def api_menu_items
    [
      ['Resources', resources_path, menu_item_id: 'resources'],
      ['Types', types_path, menu_item_id: 'types']
    ]
  end
end
