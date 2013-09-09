# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'data_mapper' 
require 'mini_magick'
require 'rack-flash'

#--------------TODO--------------
#1.  Відправки email при реєестрації
#2. -Зменшення фотографій
#3.  Створення альбомів
#4.  Оптимізація запитів до БД
#5.  Добавлення фотографій до постів
#6.  Добавити дані користувача
#7.  Реєестрація через інші сайти
#8.  Адаптивний дизайн
#9.  Редактор тексту
#10. Сторінка "Про нас" 
#11. Сторінка "Календар"
#12. Глова сторінка
#13. Зaвантаження файлів через Amazon S3
#14. AJAX запроси

# https://devcenter.heroku.com/articles/heroku-postgresql#connecting-in-ruby 
# - використовувати для налаштування бази даних і не забути DataMapper.auto_migrate!

#--------------------------------

enable :sessions
use Rack::Flash 

# Для перегляду логів запросів
DataMapper::Logger.new($stdout, :debug)

# DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://postgres:80502457135@localhost/db')
DataMapper.setup(:default, 'sqlite:db.sqlite')

Dir["./models/*.rb"].each { |file| require file }

DataMapper.auto_migrate!
#DataMapper.auto_upgrade!

Dir["./helpers/*.rb"].each { |file| require file }
Dir["./controllers/*.rb"].each { |file| require file }