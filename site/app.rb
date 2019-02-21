require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

get('/') do
    slim(:index)
end

get('/opps') do
    slim(:opps)
end

get('/register') do
    slim(:register)
end

get('/logged') do
    slim(:logged)
end

post('/register/new') do
    db = SQLite3::Database.new("db/blogg.db")
    hash_passsword = BCrypt::Password.create(params["password"])
    db.execute('INSERT INTO User(username, password) VALUES ((?), (?))', params["username"], hash_passsword)
    redirect('/') 
end

post('/login') do
    db = SQLite3::Database.new("db/blogg.db")
    db.results_as_hash = true

    result = db.execute("SELECT username, password FROM User WHERE User.username=(?)",params["username"], params["password"])
    new = result[0]
    if params["username"] == new[0] && BCrypt::Password.new(hash_passsword) == new[1]
        redirect('/logged')
    else 
        redirect('/opps')
    end
end 


