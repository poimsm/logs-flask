from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.dialects.postgresql import UUID
import uuid
from datetime import datetime
import os

app = Flask(__name__)

# Configuración de la base de datos PostgreSQL usando las variables de entorno del archivo .env
app.config['SQLALCHEMY_DATABASE_URI'] = f"postgresql://{os.getenv('DB_USER')}:{os.getenv('DB_PASS')}@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Inicializar SQLAlchemy
db = SQLAlchemy(app)

# Definir el modelo Device
class Device(db.Model):
    __tablename__ = 'devices'
    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, nullable=False)
    name = db.Column(db.String(80), nullable=False)

    def __repr__(self):
        return f'<Device {self.name}>'

# Definir el modelo Log
class Log(db.Model):
    __tablename__ = 'logs'
    id = db.Column(db.Integer, primary_key=True)
    value = db.Column(db.String(200), nullable=False)
    screen_size = db.Column(db.String(50), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    device_id = db.Column(UUID(as_uuid=True), db.ForeignKey('devices.id'), nullable=False)

    # Relación con el modelo Device
    device = db.relationship('Device', backref=db.backref('logs', lazy=True))

    def __repr__(self):
        return f'<Log {self.value} for Device {self.device_id}>'

# Ruta para crear un nuevo dispositivo
@app.route('/create-device', methods=['POST'])
def create_device():
    device_name = request.json.get('name', 'Unnamed Device')
    new_device = Device(name=device_name)
    db.session.add(new_device)
    db.session.commit()
    return jsonify({"device_id": str(new_device.id), "message": "Device created successfully!"})

# Ruta para agregar un nuevo log a un dispositivo
@app.route('/add-log/<uuid:device_id>', methods=['POST'])
def add_log(device_id):
    device = Device.query.get_or_404(device_id)
    
    value = request.json.get('value')
    screen_size = request.json.get('screen_size')

    if not value or not screen_size:
        return jsonify({"error": "Missing value or screen_size"}), 400

    new_log = Log(value=value, screen_size=screen_size, device_id=device.id)
    db.session.add(new_log)
    db.session.commit()

    return jsonify({"message": "Log added successfully!", "log_id": new_log.id})

# Ruta para obtener todos los logs de un dispositivo
@app.route('/device-logs/<uuid:device_id>', methods=['GET'])
def get_device_logs(device_id):
    device = Device.query.get_or_404(device_id)
    logs = [{"id": log.id, "value": log.value, "screen_size": log.screen_size, "created_at": log.created_at} for log in device.logs]
    return jsonify({"device_id": str(device.id), "logs": logs})

# Endpoint para validar que el servidor está funcionando
@app.route('/hello', methods=['GET'])
def hello():
    return "Hello, the server is running!", 200

# if __name__ == '__main__':
#     with app.app_context():
#         try:
#             db.create_all()  # Crear las tablas si no existen
#             print("Tablas creadas exitosamente.")
#         except Exception as e:
#             print(f"Error al crear las tablas: {e}")

#     app.run(debug=True)

