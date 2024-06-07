const express = require('express');
const mysql = require('mysql2');
const fs = require('fs');
const csv = require('csv-parser');
const path = require('path');
const app = express();
const port = 3000;

const dbConfig = {
    host: 'localhost',
    user: 'root',
    password: 'rootpassword',
    database: 'project_database'
};

// Function to create tables
function createTables(connection) {
    const createQueries = fs.readFileSync('database.sql', 'utf8');
    
    // Split the contents of database.sql into individual statements
    const statements = createQueries.split(';');

    // Execute each statement
    statements.forEach((statement) => {
        if (statement.trim()) { // Check if the statement is not empty
            connection.query(statement.trim(), (err, results) => {
                if (err) {
                    console.error('Error executing SQL statement:', err);
                } else {
                    console.log('SQL statement executed successfully');
                }
            });
        }
    });

    // Populate tables after creation
    populateTables(connection);
}

// Function to populate tables with data from CSV files
function populateTables(connection) {
    // Define mappings of table names to CSV files
    const tableMappings = {
        Employee: 'Employees.csv',
        Customer: 'Customers.csv',
        Building: 'Buildings.csv',
        Room: 'Rooms.csv',
        Course: 'Courses.csv', //TODO
        Housekeeper: 'PhoneNumbers.csv'
    };

    // Iterate over each table mapping and process corresponding CSV file
    for (const table in tableMappings) {
        if (tableMappings.hasOwnProperty(table)) {
            const csvFiles = tableMappings[table];
            const filePath = typeof csvFiles === 'string' ? csvFiles : csvFiles[table];

            if (filePath) { // Check if filePath is defined
                fs.createReadStream(path.join(__dirname, 'Data', filePath))
                    .pipe(csv())
                    .on('data', (row) => {
						const columns = Object.keys(row).join(',');
						let values = Object.values(row).map(value => {
							if (value === '') {
								return 'NULL'; // Replace empty string with NULL
							} else {
								// Escape single quotes in values
								return `'${value.replace(/'/g, "''")}'`;
							}
						}).join(',');

						const query = `INSERT IGNORE INTO ${table} (${columns}) VALUES (${values})`;

						connection.query(query, (err, results) => {
							if (err) {
								console.error('Error inserting data into', table, ':', err);
							} else {
								console.log(`Inserted into ${table}: ${values}`);
							}
						});
					})
					.on('end', () => {
						console.log(`CSV file ${filePath}.csv successfully processed`);
					});

            }
        }
    }
}

app.post('/populate', (req, res) => {
    const connection = mysql.createConnection(dbConfig);

    connection.connect(err => {
        if (err) {
            console.error('Error connecting to the database:', err);
            res.status(500).json({ error: 'Database connection failed' });
            return;
        }
        console.log('Connected to the database');

        // Create tables
        createTables(connection);

        res.json({ message: 'Database population started' });
    });
});

app.get('/data/Employee', (req, res) => {
    const connection = mysql.createConnection(dbConfig);

    connection.connect(err => {
        if (err) {
            console.error('Error connecting to the database:', err);
            res.status(500).json({ error: 'Database connection failed' });
            return;
        }
        console.log('Connected to the database');

        connection.query('SELECT * FROM Employee ORDER BY RAND() LIMIT 50', (err, results) => {
            connection.end(); 

            if (err) {
                console.error('Error fetching data:', err);
                res.status(500).json({ error: 'Error fetching data from database' });
                return;
            }

            res.json(results); 
        });
    });
});

app.get('/data/Supervise', async (req, res) => {
    try {
        const connection = mysql.createConnection(dbConfig);
        await connect(connection);

        console.log('Connected to the database');

        const results = await query(connection, 'SELECT * FROM Supervise');
        connection.end();

        res.json(results);
    } catch (error) {
        console.error('Error fetching supervise data:', error);
        res.status(500).json({ error: 'Error fetching data from database' });
    }
});

// Funktionen für Verbindung und Abfrage

function connect(connection) {
    return new Promise((resolve, reject) => {
        connection.connect(err => {
            if (err) {
                reject(err);
            } else {
                resolve();
            }
        });
    });
}

function query(connection, sql) {
    return new Promise((resolve, reject) => {
        connection.query(sql, (err, results) => {
            if (err) {
                reject(err);
            } else {
                resolve(results);
            }
        });
    });
}

// Fetch data for courses
app.get('/data/Course', (req, res) => {
    const connection = mysql.createConnection(dbConfig);

    connection.connect(err => {
        if (err) {
            console.error('Error connecting to the database:', err);
            res.status(500).json({ error: 'Database connection failed' });
            return;
        }
        console.log('Connected to the database');

        // Select only the Course_ID and Title columns
        connection.query('SELECT Course_ID FROM Course', (err, results) => {
            connection.end(); // End the database connection

            if (err) {
                console.error('Error fetching data:', err);
                res.status(500).json({ error: 'Error fetching data from database' });
                return;
            }

            res.json(results); // Send the retrieved data as JSON response
        });
    });
});

// Link employee and course
app.post('/link', (req, res) => {
    const { employeeId, courseId } = req.query;

    const connection = mysql.createConnection(dbConfig);

    connection.connect(err => {
        if (err) {
            console.error('Error connecting to the database:', err);
            res.status(500).json({ error: 'Database connection failed' });
            return;
        }
        console.log('Connected to the database');

        const query = `INSERT INTO Supervise (SL_ID, Course_ID) VALUES (${employeeId}, ${courseId})`;

        connection.query(query, (err, results) => {
            connection.end(); // End the database connection

            if (err) {
                console.error('Error linking employee and course:', err);
                res.status(500).json({ error: 'Error linking employee and course' });
                return;
            }

            res.json({ message: 'Employee and course linked successfully' });
        });
    });
});

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
});