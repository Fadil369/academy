# Academy - BrainsAIT Moodle Plugin

A comprehensive Moodle local plugin for automated content creation and management using AI-powered tools.

## Features

- **Content Generation**: AI-powered content creation tools
- **MCP Integration**: Model Context Protocol integration for content processing
- **Moodle Integration**: Seamless integration with Moodle LMS
- **Automated Workflows**: Scripts for setup and deployment
- **Localization**: Multi-language support

## Project Structure

- `automate-moodle.py` - Main automation script for Moodle operations
- `content-generator-mcp.py` - AI content generation using MCP
- `moodle-mcp-integration.py` - Moodle and MCP integration layer
- `setup-moodle-webservices.sh` - Automated Moodle web services setup
- `mcp-content-server.json` - MCP server configuration
- `lang/` - Language files for internationalization
- `moodle-sample.html` - Sample Moodle content template
- `moodle-theme.css` - Custom styling for Moodle components
- `version.php` - Plugin version information
- `scripts/` - Deployment and utility scripts
- `src/` - Additional source code

## Installation

1. Clone this repository to your Moodle `/local/brainsait/` directory
2. Run the setup script: `./setup-moodle-webservices.sh`
3. Visit Site Administration in Moodle to complete plugin installation
4. Configure MCP settings using `mcp-content-server.json`

## Development

1. Clone this repository
2. Install Python dependencies for automation scripts
3. Configure your Moodle instance
4. Start development and testing

## Deployment

This project is automatically deployed to the server when changes are pushed to the main branch.
