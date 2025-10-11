# EnvQMon API Documentation

This documentation provides details for interacting with the EnvQMon API. The base URL for all endpoints is `https://api.envqmon.sayan.fit/api`. All requests and responses use JSON format, and authentication is required for most endpoints using a Bearer token.

---

## Authentication

### Register
Create a new user account.

- **Endpoint**: `POST /auth/register`
- **Headers**:
  - `Content-Type: application/json`
- **Body**:
  ```json
  {
      "name": "string",
      "email": "string",
      "password": "string"
  }
  ```
- **Response** (201 Created):
  ```json
  {
      "user_id": "uuid",
      "role": "string",
      "is_active": boolean,
      "created_at": "timestamp",
      "updated_at": "timestamp",
      "name": "string",
      "email": "string",
      "password_hash": "string"
  }
  ```
- **Example**:
  ```json
  {
      "name": "Sayan Chakraborty",
      "email": "sayan@example.com",
      "password": "testpassword"
  }
  ```
  Response:
  ```json
  {
      "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35",
      "role": "user",
      "is_active": true,
      "created_at": "2025-08-02T07:40:23.305Z",
      "updated_at": "2025-08-02T07:40:23.305Z",
      "name": "Sayan C",
      "email": "sayanc@example.com",
      "password_hash": "$2b$10$AZ.pwNeeNf8dN0IG979R9uplcX8iJsgEUlMPPMi4DDFiRYaVsHZsy"
  }
  ```

### Login
Authenticate a user and obtain an access token.

- **Endpoint**: `POST /auth/login`
- **Headers**:
  - `Content-Type: application/json`
- **Body**:
  ```json
  {
      "email": "string",
      "password": "string"
  }
  ```
- **Response** (200 OK):
  ```json
  {
      "message": "string",
      "access_token": "string",
      "user": {
          "user_id": "uuid",
          "email": "string",
          "name": "string",
          "roles": [],
          "is_active": boolean
      }
  }
  ```
- **Example**:
  ```json
  {
      "email": "sayan@example.com",
      "password": "testpassword"
  }
  ```
  Response:
  ```json
  {
      "message": "Login successful",
      "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "user": {
          "user_id": "264c8f1b-ba4b-4849-a076-62ebe8c8e0ae",
          "email": "sayan@example.com",
          "name": "Sayan Chakraborty",
          "roles": [],
          "is_active": true
      }
  }
  ```

---

## User Management (Admin Only)

### Get All Users
Retrieve a list of all users (admin access required).

- **Endpoint**: `GET /auth/users`
- **Headers**:
  - `Authorization: Bearer <access_token>`
- **Response** (200 OK):
  ```json
  [
      {
          "user_id": "uuid",
          "name": "string",
          "email": "string",
          "role": "string",
          "is_active": boolean,
          "created_at": "timestamp",
          "updated_at": "timestamp"
      }
  ]
  ```
- **Example**:
  Response:
  ```json
  [
      {
          "user_id": "264c8f1b-ba4b-4849-a076-62ebe8c8e0ae",
          "name": "Sayan Chakraborty",
          "email": "sayan@example.com",
          "role": "admin",
          "is_active": true,
          "created_at": "2025-08-02T07:28:08.972Z",
          "updated_at": "2025-08-02T07:28:08.972Z"
      },
      {
          "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35",
          "name": "Sayan C",
          "email": "sayanc@example.com",
          "role": "user",
          "is_active": true,
          "created_at": "2025-08-02T07:40:23.305Z",
          "updated_at": "2025-08-02T07:40:23.305Z"
      }
  ]
  ```

### Edit User Password
Update a user's password (admin access required).

- **Endpoint**: `PUT /auth/users/<user_id>`
- **Headers**:
  - `Authorization: Bearer <access_token>`
  - `Content-Type: application/json`
- **Body**:
  ```json
  {
      "email": "string",
      "password": "string"
  }
  ```
- **Response** (200 OK):
  ```json
  {
      "user_id": "uuid",
      "name": "string",
      "email": "string",
      "is_active": boolean,
      "created_at": "timestamp",
      "updated_at": "timestamp"
  }
  ```
- **Example**:
  ```json
  {
      "email": "sayanc@example.com",
      "password": "testpassword1234"
  }
  ```
  Response:
  ```json
  {
      "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35",
      "name": "Sayan C",
      "email": "sayanc@example.com",
      "is_active": true,
      "created_at": "2025-08-02T07:40:23.305Z",
      "updated_at": "2025-08-02T07:40:23.305Z"
  }
  ```

---

## Home Management

### Create Home
Create a new home for a user.

- **Endpoint**: `POST /homes`
- **Headers**:
  - `Authorization: Bearer <access_token>`
  - `Content-Type: application/json`
- **Body**:
  ```json
  {
      "home_name": "string",
      "address": "string",
      "user_id": "uuid"
  }
  ```
- **Response** (201 Created):
  ```json
  {
      "home_id": "uuid",
      "home_name": "string",
      "address": "string",
      "user_id": "uuid",
      "createdAt": "timestamp",
      "updatedAt": "timestamp"
  }
  ```
- **Example**:
  ```json
  {
      "home_name": "My Home",
      "address": "1/A DBC Road, BHT, PKJ, IND, 123456",
      "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35"
  }
  ```
  Response:
  ```json
  {
      "home_id": "44c43d30-560e-4bb6-afa0-f8664f6ea435",
      "home_name": "My Home",
      "address": "1/A DBC Road, BHT, PKJ, IND, 123456",
      "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35",
      "updatedAt": "2025-08-02T09:11:25.260Z",
      "createdAt": "2025-08-02T09:11:25.260Z"
  }
  ```

### Get Home by ID
Retrieve details of a specific home.

- **Endpoint**: `GET /homes/<home_id>`
- **Headers**:
  - `Authorization: Bearer <access_token>`
- **Response** (200 OK):
  ```json
  {
      "home_id": "uuid",
      "home_name": "string",
      "user_id": "uuid",
      "address": "string",
      "createdAt": "timestamp",
      "updatedAt": "timestamp"
  }
  ```
- **Example**:
  Response:
  ```json
  {
      "home_id": "44c43d30-560e-4bb6-afa0-f8664f6ea435",
      "home_name": "My Home",
      "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35",
      "address": "1/A DBC Road, BHT, PKJ, IND, 123456",
      "createdAt": "2025-08-02T09:11:25.260Z",
      "updatedAt": "2025-08-02T09:11:25.260Z"
  }
  ```

### Get All Homes
Retrieve a list of all homes for a user.

- **Endpoint**: `GET /homes`
- **Headers**:
  - `Authorization: Bearer <access_token>`
- **Response** (200 OK):
  ```json
  [
      {
          "home_id": "uuid",
          "home_name": "string",
          "user_id": "uuid",
          "address": "string",
          "createdAt": "timestamp",
          "updatedAt": "timestamp"
      }
  ]
  ```
- **Example**:
  Response:
  ```json
  [
      {
          "home_id": "7737f05a-0ff3-4359-a583-2c5059542b18",
          "home_name": "My Home",
          "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35",
          "address": null,
          "createdAt": "2025-08-02T09:10:18.521Z",
          "updatedAt": "2025-08-02T09:10:18.521Z"
      },
      {
          "home_id": "44c43d30-560e-4bb6-afa0-f8664f6ea435",
          "home_name": "My Home",
          "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35",
          "address": "1/A DBC Road, BHT, PKJ, IND, 123456",
          "createdAt": "2025-08-02T09:11:25.260Z",
          "updatedAt": "2025-08-02T09:11:25.260Z"
      }
  ]
  ```

---

## Room Management

### Create Room
Create a new room in a home.

- **Endpoint**: `POST /rooms`
- **Headers**:
  - `Authorization: Bearer <access_token>`
  - `Content-Type: application/json`
- **Body**:
  ```json
  {
      "room_name": "string",
      "home_id": "uuid",
      "user_id": "uuid"
  }
  ```
- **Response** (201 Created):
  ```json
  {
      "room_id": "uuid",
      "room_name": "string",
      "home_id": "uuid",
      "user_id": "uuid",
      "type": null,
      "createdAt": "timestamp",
      "updatedAt": "timestamp"
  }
  ```
- **Example**:
  ```json
  {
      "room_name": "Living Room",
      "home_id": "44c43d30-560e-4bb6-afa0-f8664f6ea435",
      "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35"
  }
  ```
  Response:
  ```json
  {
      "room_id": "e2dabe95-bad9-4327-8f55-6f2c36883948",
      "room_name": "Living Room",
      "home_id": "44c43d30-560e-4bb6-afa0-f8664f6ea435",
      "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35",
      "updatedAt": "2025-08-02T09:20:58.683Z",
      "createdAt": "2025-08-02T09:20:58.683Z",
      "type": null
  }
  ```

### Get All Rooms
Retrieve a list of all rooms for a user.

- **Endpoint**: `GET /rooms`
- **Headers**:
  - `Authorization: Bearer <access_token>`
- **Response** (200 OK):
  ```json
  [
      {
          "room_id": "uuid",
          "room_name": "string",
          "home_id": "uuid",
          "user_id": "uuid",
          "type": null,
          "createdAt": "timestamp",
          "updatedAt": "timestamp"
      }
  ]
  ```
- **Example**:
  Response:
  ```json
  [
      {
          "room_id": "11d21ad7-e396-42c4-9344-2d7fe25cdad0",
          "room_name": "Bedroom",
          "home_id": "44c43d30-560e-4bb6-afa0-f8664f6ea435",
          "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35",
          "type": null,
          "createdAt": "2025-08-02T09:20:37.092Z",
          "updatedAt": "2025-08-02T09:20:37.092Z"
      },
      {
          "room_id": "e2dabe95-bad9-4327-8f55-6f2c36883948",
          "room_name": "Living Room",
          "home_id": "44c43d30-560e-4bb6-afa0-f8664f6ea435",
          "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35",
          "type": null,
          "createdAt": "2025-08-02T09:20:58.683Z",
          "updatedAt": "2025-08-02T09:20:58.683Z"
      }
  ]
  ```

---

## Device Management

### Create Device
Register a new device for a user.

- **Endpoint**: `POST /devices`
- **Headers**:
  - `Authorization: Bearer <access_token>`
  - `Content-Type: application/json`
- **Body**:
  ```json
  {
      "device_name": "string",
      "device_imei": "string",
      "user_id": "uuid"
  }
  ```
- **Response** (201 Created):
  ```json
  {
      "device_id": "uuid",
      "is_active": boolean,
      "device_name": "string",
      "device_imei": "string",
      "user_id": "uuid",
      "createdAt": "timestamp",
      "updatedAt": "timestamp"
  }
  ```
- **Example**:
  ```json
  {
      "device_name": "TEST1",
      "device_imei": "TEST1234554322",
      "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35"
  }
  ```
  Response:
  ```json
  {
      "device_id": "c755fc04-4ded-4e9a-a1ef-de7eb4c95514",
      "is_active": true,
      "device_name": "TEST1",
      "device_imei": "TEST1234554322",
      "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35",
      "updatedAt": "2025-08-02T10:52:53.325Z",
      "createdAt": "2025-08-02T10:52:53.325Z"
  }
  ```

### Get All Devices
Retrieve a list of all devices for a user.

- **Endpoint**: `GET /devices`
- **Headers**:
  - `Authorization: Bearer <access_token>`
- **Response** (200 OK):
  ```json
  [
      {
          "device_id": "uuid",
          "is_active": boolean,
          "device_name": "string",
          "device_imei": "string",
          "user_id": "uuid",
          "createdAt": "timestamp",
          "updatedAt": "timestamp"
      }
  ]
  ```
- **Example**:
  Response:
  ```json
  [
      {
          "device_id": "c755fc04-4ded-4e9a-a1ef-de7eb4c95514",
          "is_active": true,
          "device_name": "TEST1",
          "device_imei": "TEST1234554322",
          "user_id": "fecfb896-5b1f-4e84-bf0a-48ae3d4d7f35",
          "updatedAt": "2025-08-02T10:52:53.325Z",
          "createdAt": "2025-08-02T10:52:53.325Z"
      }
  ]
  ```

---

## Device Data

### Get Latest Device Data
Retrieve the latest environmental data for a specific device.

- **Endpoint**: `GET /data/latest/<device_id>`
- **Headers**:
  - `Authorization: Bearer <access_token>`
- **Response** (200 OK):
  ```json
  {
      "id": "string",
      "device_id": "uuid",
      "temperature": float,
      "humidity": float,
      "pressure": float,
      "co": float,
      "methane": float,
      "lpg": float,
      "pm25": float,
      "pm10": float,
      "noise": float,
      "light": float,
      "recorded_at": "timestamp"
  }
  ```
- **Example**:
  Response:
  ```json
  {
      "id": "4",
      "device_id": "566ed335-beb7-4973-8c7c-324346b28533",
      "temperature": 27.08,
      "humidity": 41.32,
      "pressure": 1041.6,
      "co": 2.56,
      "methane": 452.79,
      "lpg": 616.06,
      "pm25": 290.99,
      "pm10": 291.92,
      "noise": 67.95,
      "light": 336.01,
      "recorded_at": "1754133743"
  }
  ```

### Get Device Data by Time Range
Retrieve environmental data for a device within a specified time range.

- **Endpoint**: `GET /data/<device_id>?start=<timestamp>&end=<timestamp>`
- **Headers**:
  - `Authorization: Bearer <access_token>`
- **Response** (200 OK):
  ```json
  [
      {
          "id": "string",
          "device_id": "uuid",
          "temperature": float,
          "humidity": float,
          "pressure": float,
          "co": float,
          "methane": float,
          "lpg": float,
          "pm25": float,
          "pm10": float,
          "noise": float,
          "light": float,
          "recorded_at": "timestamp"
      }
  ]
  ```
- **Example**:
  Response (truncated for brevity):
  ```json
  [
      {
          "id": "153",
          "device_id": "566ed335-beb7-4973-8c7c-324346b28533",
          "temperature": 21.6,
          "humidity": 52.2,
          "pressure": 974.61,
          "co": 0.26,
          "methane": 378.56,
          "lpg": 567.6,
          "pm25": 162.19,
          "pm10": 23.56,
          "noise": 88.79,
          "light": 768.94,
          "recorded_at": "1754134488"
      },
      {
          "id": "154",
          "device_id": "566ed335-beb7-4973-8c7c-324346b28533",
          "temperature": 30.3,
          "humidity": 47.26,
          "pressure": 1030.1,
          "co": 3.22,
          "methane": 29.22,
          "lpg": 943.62,
          "pm25": 64.03,
          "pm10": 338.74,
          "noise": 37.84,
          "light": 245.98,
          "recorded_at": "1754134493"
      }
  ]
  ```

---

## Notes
- **Base URL**: `https://api.envqmon.sayan.fit/api`
- **Authentication**: Most endpoints require a Bearer token obtained from the `/auth/login` endpoint. Include it in the `Authorization` header as `Bearer <access_token>`.
- **Content-Type**: All requests with a body require `Content-Type: application/json`.
- **Timestamps**: Use ISO 8601 format for `createdAt`, `updatedAt`, and `recorded_at` fields.
- **Admin Access**: Endpoints like `/auth/users` and `/auth/users/<user_id>` require admin privileges.

This API allows users to manage homes, rooms, devices, and retrieve environmental data efficiently.