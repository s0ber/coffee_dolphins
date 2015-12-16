module MenuHelper
  def menu_items
    [
      ['Букмейкеры', bookmakers_path, menu_item_id: 'bookmakers'],
      ['Линии ставок', bet_lines_path, menu_item_id: 'bet_lines'],
      ['Активные вилки', forks_path, menu_item_id: 'forks'],
      ['Пользователи', users_path, menu_item_id: 'users']
    ]
  end
end
