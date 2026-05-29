PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS room_reservation;
DROP TABLE IF EXISTS hotel_room;
DROP TABLE IF EXISTS hotel;

CREATE TABLE hotel (
    hotel_id INTEGER,
    name TEXT NOT NULL,
    city TEXT NOT NULL,
    address TEXT NOT NULL,
    description TEXT,
    rating REAL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (hotel_id)
);

CREATE TABLE hotel_room (
    room_id INTEGER,
    hotel_id INTEGER NOT NULL,
    room_type TEXT NOT NULL,
    room_number TEXT,
    capacity INTEGER NOT NULL,
    price_per_night REAL NOT NULL,
    amenities TEXT,
    is_available BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (room_id),
    FOREIGN KEY (hotel_id) REFERENCES hotel (hotel_id)
);

CREATE TABLE room_reservation (
    reservation_id INTEGER,
    room_id INTEGER NOT NULL,
    guest_name TEXT,
    guest_email TEXT,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_amount REAL,
    status TEXT DEFAULT 'confirmed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (reservation_id),
    FOREIGN KEY (room_id) REFERENCES hotel_room (room_id),
    CHECK (status IN ('confirmed', 'cancelled', 'completed'))
);

INSERT INTO hotel (
    hotel_id,
    name,
    city,
    address,
    description,
    rating,
    created_at
) VALUES
    (1, 'Tokyo Grand Hotel', 'Tokyo', '1-1-1 Shibuya, Tokyo', 'Luxury hotel in the heart of Tokyo with modern amenities', 4.5, '2025-06-01 10:07:43'),
    (2, 'Sakura Onsen Resort', 'Tokyo', '2-3-4 Harajuku, Tokyo', 'Traditional Japanese hotel with natural hot springs and spa services', 4.8, '2025-06-01 10:07:43'),
    (3, 'Tokyo Business Hotel', 'Tokyo', '5-6-7 Shinjuku, Tokyo', 'Modern business hotel with gym and conference facilities', 4.2, '2025-06-01 10:07:43'),
    (4, 'Imperial Palace Hotel', 'Tokyo', '8-9-10 Chiyoda, Tokyo', 'Elegant hotel near Imperial Palace with premium services', 4.7, '2025-06-01 10:07:43'),
    (5, 'Zen Garden Hotel', 'Tokyo', '11-12-13 Asakusa, Tokyo', 'Peaceful hotel with traditional garden and hot springs', 4.6, '2025-06-01 10:07:43'),
    (6, 'Osaka Bay Hotel', 'Osaka', '1-2-3 Namba, Osaka', 'Waterfront hotel with beautiful bay views', 4.3, '2025-06-01 10:07:43'),
    (7, 'Kyoto Heritage Inn', 'Kyoto', '4-5-6 Gion, Kyoto', 'Traditional ryokan with cultural experiences', 4.9, '2025-06-01 10:07:43'),
    (8, 'Hiroshima Peace Hotel', 'Hiroshima', '7-8-9 Peace Memorial, Hiroshima', 'Modern hotel near Peace Memorial Park', 4.1, '2025-06-01 10:07:43'),
    (9, 'New York Central', 'New York', '123 5th Avenue, New York', 'Contemporary hotel in Manhattan with rooftop pool', 4.4, '2025-06-01 10:07:43'),
    (10, 'London Thames Hotel', 'London', '456 River Street, London', 'Riverside hotel with traditional English charm', 4.3, '2025-06-01 10:07:43'),
    (11, 'Paris Boutique Hotel', 'Paris', '789 Champs Elysees, Paris', 'Chic boutique hotel with spa facilities', 4.6, '2025-06-01 10:07:43'),
    (12, 'Hotel Sakura Onsen', 'Tokyo', '5-10-15 Shibuya', NULL, 4.5, '2026-05-05 22:00:05');

INSERT INTO hotel_room (
    room_id,
    hotel_id,
    room_type,
    room_number,
    capacity,
    price_per_night,
    amenities,
    is_available,
    created_at
) VALUES
    (1, 1, 'Standard', '101', 2, 15000.0, 'gym,pool,free parking,wifi', 1, '2025-06-01 10:07:43'),
    (2, 1, 'Deluxe', '201', 3, 22000.0, 'gym,pool,spa,free parking,wifi,shuttle service', 1, '2025-06-01 10:07:43'),
    (3, 1, 'Suite', '301', 4, 35000.0, 'gym,pool,spa,free parking,wifi,shuttle service,room service', 1, '2025-06-01 10:07:43'),
    (4, 2, 'Traditional', '101', 2, 18000.0, 'hot springs,spa,free parking,wifi', 1, '2025-06-01 10:07:43'),
    (5, 2, 'Premium Onsen', '201', 3, 28000.0, 'hot springs,spa,traditional bath,wifi,shuttle service', 1, '2025-06-01 10:07:43'),
    (6, 2, 'Royal Onsen Suite', '301', 4, 40000.0, 'hot springs,spa,traditional bath,private onsen,wifi,shuttle service', 1, '2025-06-01 10:07:43'),
    (7, 3, 'Business', '101', 2, 12000.0, 'gym,wifi,shuttle service', 1, '2025-06-01 10:07:43'),
    (8, 3, 'Executive', '201', 2, 18000.0, 'gym,wifi,shuttle service,business center', 1, '2025-06-01 10:07:43'),
    (9, 4, 'Premium', '101', 2, 25000.0, 'spa,pool,gym,free parking,wifi,shuttle service', 1, '2025-06-01 10:07:43'),
    (10, 4, 'Imperial Suite', '201', 4, 45000.0, 'spa,pool,gym,free parking,wifi,shuttle service,concierge', 1, '2025-06-01 10:07:43'),
    (11, 5, 'Garden View', '101', 2, 20000.0, 'hot springs,traditional garden,spa,wifi', 1, '2025-06-01 10:07:43'),
    (12, 5, 'Zen Suite', '201', 3, 32000.0, 'hot springs,traditional garden,spa,private garden,wifi', 1, '2025-06-01 10:07:43'),
    (13, 6, 'Bay View', '101', 2, 16000.0, 'pool,gym,wifi', 1, '2025-06-01 10:07:43'),
    (14, 7, 'Traditional Ryokan', '101', 4, 35000.0, 'traditional bath,cultural experience,wifi', 1, '2025-06-01 10:07:43'),
    (15, 8, 'Peace Memorial', '101', 2, 14000.0, 'gym,wifi,shuttle service', 1, '2025-06-01 10:07:43'),
    (16, 9, 'Manhattan View', '101', 2, 20000.0, 'pool,gym,wifi,shuttle service', 1, '2025-06-01 10:07:43'),
    (17, 10, 'Thames View', '101', 2, 18000.0, 'traditional decor,wifi,shuttle service', 1, '2025-06-01 10:07:43'),
    (18, 11, 'Boutique Suite', '101', 2, 22000.0, 'spa,wifi,boutique amenities', 1, '2025-06-01 10:07:43');

INSERT INTO room_reservation (
    reservation_id,
    room_id,
    guest_name,
    guest_email,
    check_in_date,
    check_out_date,
    total_amount,
    status,
    created_at
) VALUES
    (1, 1, 'John Smith', 'john@example.com', '2024-02-15', '2024-02-18', 45000.0, 'completed', '2025-06-01 10:07:43'),
    (2, 3, 'Alice Johnson', 'alice@example.com', '2024-03-01', '2024-03-05', 88000.0, 'confirmed', '2025-06-01 10:07:43'),
    (3, 5, 'Bob Wilson', 'bob@example.com', '2024-03-10', '2024-03-15', 175000.0, 'confirmed', '2025-06-01 10:07:43'),
    (4, 7, 'Carol Davis', 'carol@example.com', '2024-01-20', '2024-01-25', 90000.0, 'completed', '2025-06-01 10:07:43'),
    (5, 9, 'David Brown', 'david@example.com', '2024-04-01', '2024-04-07', 126000.0, 'confirmed', '2025-06-01 10:07:43'),
    (6, 11, 'Eve Miller', 'eve@example.com', '2025-03-03', '2025-03-10', 224000.0, 'confirmed', '2025-06-01 10:07:43'),
    (7, 13, 'Frank Garcia', 'frank@example.com', '2025-03-05', '2025-03-12', 175000.0, 'confirmed', '2025-06-01 10:07:43');
