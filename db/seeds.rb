# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Sergey
User.create!(email: 'coffeedolphins@gmail.com', password: 'defaultpassword', password_confirmation: 'defaultpassword', full_name: 'Сергей')

# Rita
User.create!(email: 'pumasemushina@gmail.com', password: 'defaultpassword', password_confirmation: 'defaultpassword', full_name: 'Рита')
