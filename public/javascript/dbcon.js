// const sqlite3 = require('sqlite3').verbose();

// // open the database
// let db = new sqlite3.Database('./db/development.sqlite');
// let sql = `SELECT state state,
// iata_code airport,
// name name
// FROM airports`;
// db.all(sql, [], (err, rows) => {
//     if (err) {
//         throw err;
//     }
//     rows.forEach((row) => {
//         combinedData = `${row.name}, ${row.state}, ${row.airport}`
//         console.log(combinedData);
//     });
// });