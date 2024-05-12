from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL

app = Flask(__name__, static_url_path='/static')
app.secret_key = '123'

app.config['MYSQL_HOST'] = '127.0.0.1'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'project'

mysql = MySQL(app)

@app.route('/')
def home():
    return render_template('login.html')
   

@app.route('/login', methods=['POST'])
def login():
    id = request.form['id']

    password = request.form['password']
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM login WHERE id = %s AND pass = %s", (id, password))
    user = cur.fetchall()
    

    if id == '100' and password == '123789' :
         return dashboard()
    else:
        return redirect(url_for('student',id= id))  # Redirect with user ID as query parameter
            # return redirect(url_for('home', id=user[0]))  # Redirect with user ID as query parameter
    # else:
        #  return 'Invalid username or password. Please try again.'

@app.route('/dashboard')
def dashboard():
   cur = mysql.connection.cursor()
   cur.execute("select l.user_name, e.id, c.crs_title, g.grade_value, g.CGPA from enrollment e join login l on e.id = l.id join course c on e.crs_id = c.crs_id join grade g on e.enroll_id = g.enroll_id ;")
   std = cur.fetchall()
   cur.close()
   return render_template('admin_dashboard.html',users=std)

@app.route('/student/<int:id>')
def student(id):
    # Fetch and display information specific to the logged-in student
    cur = mysql.connection.cursor()
    cur.execute("SELECT l.user_name, e.id, c.crs_title, g.grade_value, g.CGPA FROM enrollment e JOIN login l ON e.id = l.id JOIN course c ON e.crs_id = c.crs_id JOIN grade g ON e.enroll_id = g.enroll_id WHERE e.id = %s;", (id,))
    data = cur.fetchall()
    cur.close() 
    return render_template('home.html',users=data)

@app.after_request
def after_request(response):
    response.headers['Content-Type'] = 'text/html; charset=utf-8'
    return response

@app.route('/static/<path:filename>')
def serve_static(filename):
    return app.send_static_file(filename)



if __name__ == '__main__':
    app.run(debug=True)