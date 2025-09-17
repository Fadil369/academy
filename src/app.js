console.log("Welcome to Academy Project!");

// Main application entry point
function main() {
    console.log("Academy application is running...");
}

if (require.main === module) {
    main();
}

module.exports = { main };