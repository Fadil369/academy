# BrainsAIT Generator - Moodle Local Plugin

AI-powered course content generation and LMS integration for Moodle.

## Features

- **Automated Course Generation**: Creates comprehensive course structures with modules, lessons, and assessments
- **Interactive Presentations**: Generates HTML5 slides with navigation and responsive design
- **Moodle Integration**: Produces ready-to-import .mbz backup files
- **Admin Interface**: Simple UI for triggering generation and managing outputs
- **Public Hosting**: Optional nginx configuration for serving presentations

## Installation

### Via File Upload (Recommended)
1. Download the plugin package from the `dist/` directory
2. In Moodle: Site administration → Plugins → Install plugins
3. Upload the .zip file and follow installation wizard

### Via Server Deployment
1. Run the deployment script: `scripts/deploy-plugin.sh`
2. Complete installation: Site administration → Notifications

## Usage

### Generate Course Content
1. Site administration → Plugins → Local plugins → BrainsAIT Generator
2. Click "Run Generation"
3. View logs and download generated .mbz file

### Configure Settings
- **Presentation Base URL**: Public URL where presentations are served
- **Public Directory**: Server path for nginx hosting (optional)

### Import Generated Course
1. Site administration → Courses → Restore
2. Upload the generated `brainsait_ai_course_backup.mbz`
3. Follow restore wizard

## CLI Usage

For automation or debugging:

```bash
# Run as web server user
sudo -u www-data php /path/to/moodle/local/brainsait/cli/run.php
```

## Public Presentation Hosting

To serve presentations at a clean URL:

1. Configure "Public Directory" setting (e.g., `/var/www/brainsait-web`)
2. Deploy nginx configuration: `scripts/deploy-nginx-presentation.sh`
3. Presentations will be available at: `https://yourdomain.com/brainsait-demo/`

## Generated Content

The plugin creates:
- **Interactive Presentation**: HTML5 slides with navigation
- **Course Structure**: 4 modules covering AI content creation, MCP integration, Moodle deployment, and advanced features
- **Assessments**: Mixed question types with explanations
- **Moodle Backup**: Complete .mbz file ready for import

## File Structure

```
plugin/local/brainsait/
├── version.php              # Plugin metadata
├── settings.php             # Admin settings
├── db/access.php           # Capabilities
├── lang/en/local_brainsait.php  # Language strings
├── classes/generator.php    # Main generator class
├── manage.php              # Admin interface
├── run.php                 # Generation trigger
├── download.php            # File download endpoint
├── cli/run.php             # Command-line interface
└── bin/
    ├── advanced-course-generator.py
    └── moodle-packager.py
```

## Requirements

- Moodle 4.1+
- Python 3.7+ (for content generation)
- Write permissions to Moodle dataroot
- Optional: nginx (for public presentation hosting)

## Support

- Repository: https://github.com/Fadil369/academy
- Documentation: Complete API docs included in generated content
- Technical Support: Available through repository issues

---

**BrainsAIT Academy** - AI-Powered Educational Technology