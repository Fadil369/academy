#!/bin/bash

echo "Moodle Web Services Setup Instructions"
echo "======================================"

echo "1. Login to Moodle as admin"
echo "2. Go to Site Administration > Server > Web services"
echo "3. Enable web services: Check 'Enable web services'"
echo "4. Enable REST protocol: Plugins > Manage protocols > Enable REST"

echo ""
echo "5. Create external service:"
echo "   - External services > Add"
echo "   - Name: 'Course Management API'"
echo "   - Shortname: 'course_api'"
echo "   - Enabled: Yes"
echo "   - Authorized users only: Yes"

echo ""
echo "6. Add functions to service:"
echo "   - Edit 'Course Management API'"
echo "   - Add functions:"
echo "     * core_course_create_courses"
echo "     * core_course_get_courses"
echo "     * core_course_create_categories"
echo "     * mod_page_add_page"
echo "     * core_webservice_get_site_info"

echo ""
echo "7. Create user and token:"
echo "   - Users > Add new user"
echo "   - Username: 'apiuser'"
echo "   - Assign system role: 'Manager'"
echo ""
echo "   - External services > 'Course Management API' > Authorized users"
echo "   - Add user: 'apiuser'"
echo ""
echo "   - Security > Manage tokens"
echo "   - Create token for user 'apiuser' and service 'Course Management API'"

echo ""
echo "8. Test with curl:"
echo 'curl -X POST "https://your-moodle.com/webservice/rest/server.php" \'
echo '  -d "wstoken=YOUR_TOKEN" \'
echo '  -d "wsfunction=core_webservice_get_site_info" \'
echo '  -d "moodlewsrestformat=json"'
