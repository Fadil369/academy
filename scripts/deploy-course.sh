#!/bin/bash

# BrainsAIT Academy Course Deployment Script
# Deploys the AI-Powered Content Creation course to production

set -e  # Exit on any error

echo "🚀 BrainsAIT Academy - Course Deployment Script"
echo "================================================"

# Configuration
LOCAL_COURSE_DIR="/Users/fadil369/academy/course_export"
SERVER_HOST="ubuntu@95.177.160.74"
SERVER_KEY="~/.ssh/cloud.key"
SERVER_COURSE_DIR="/home/ubuntu/projects/academy/live_courses"
LMS_URL="https://lms.brainsait.com"

echo "📋 Deployment Configuration:"
echo "   Local Course Dir: $LOCAL_COURSE_DIR"
echo "   Server Host: $SERVER_HOST"
echo "   Server Course Dir: $SERVER_COURSE_DIR"
echo "   LMS URL: $LMS_URL"
echo ""

# Step 1: Validate local files
echo "🔍 Step 1: Validating local course files..."
if [ ! -f "$LOCAL_COURSE_DIR/brainsait_ai_course_backup.mbz" ]; then
    echo "❌ Error: Moodle backup file not found!"
    echo "   Please run: python3 moodle-packager.py"
    exit 1
fi

if [ ! -f "$LOCAL_COURSE_DIR/interactive-presentation.html" ]; then
    echo "❌ Error: Interactive presentation not found!"
    exit 1
fi

echo "✅ Local files validated"

# Step 2: Test local presentation server
echo "🧪 Step 2: Testing local presentation..."
if curl -s http://localhost:8080/interactive-presentation.html > /dev/null; then
    echo "✅ Local presentation server is running"
else
    echo "⚠️  Local presentation server not running (this is optional)"
fi

# Step 3: Upload files to server
echo "📤 Step 3: Uploading course files to server..."

# Create server directory
ssh -i $SERVER_KEY $SERVER_HOST "mkdir -p $SERVER_COURSE_DIR"

# Upload course files
echo "   Uploading Moodle backup file..."
scp -i $SERVER_KEY "$LOCAL_COURSE_DIR/brainsait_ai_course_backup.mbz" "$SERVER_HOST:$SERVER_COURSE_DIR/"

echo "   Uploading presentation files..."
scp -i $SERVER_KEY "$LOCAL_COURSE_DIR/interactive-presentation.html" "$SERVER_HOST:$SERVER_COURSE_DIR/"
scp -r -i $SERVER_KEY "$LOCAL_COURSE_DIR/moodle_package" "$SERVER_HOST:$SERVER_COURSE_DIR/"

echo "✅ Files uploaded successfully"

# Step 4: Set up course on server
echo "🔧 Step 4: Setting up course environment on server..."
ssh -i $SERVER_KEY $SERVER_HOST << 'EOF'
cd /home/ubuntu/projects/academy/live_courses

# Create web directory for presentation
mkdir -p web_presentation
cp interactive-presentation.html web_presentation/
cd web_presentation

# Start presentation server (if not already running)
if ! pgrep -f "python3 -m http.server 8081" > /dev/null; then
    echo "Starting presentation server on port 8081..."
    nohup python3 -m http.server 8081 > presentation_server.log 2>&1 &
    echo "✅ Presentation server started"
else
    echo "✅ Presentation server already running"
fi

# Create deployment info file
cd ..
cat > deployment_info.json << EOL
{
    "course_title": "AI-Powered Content Creation and LMS Integration",
    "deployment_date": "$(date -Iseconds)",
    "backup_file": "brainsait_ai_course_backup.mbz",
    "presentation_url": "http://95.177.160.74:8081/interactive-presentation.html",
    "lms_url": "https://lms.brainsait.com",
    "version": "1.0.0",
    "status": "deployed"
}
EOL

echo "✅ Course environment set up"
EOF

# Step 5: Create deployment summary
echo "📊 Step 5: Creating deployment summary..."

cat > deployment_summary.md << EOF
# 🎯 BrainsAIT Academy Course Deployment Summary

## Course Information
- **Title**: AI-Powered Content Creation and LMS Integration
- **Version**: 1.0.0
- **Deployment Date**: $(date)
- **Status**: ✅ Successfully Deployed

## 📁 Deployed Files
- **Moodle Backup**: brainsait_ai_course_backup.mbz (Ready for LMS import)
- **Interactive Presentation**: Available at http://95.177.160.74:8081/interactive-presentation.html
- **Course Materials**: Complete module structure with 4 modules, 12 lessons

## 🌐 Access Points
- **LMS Import**: Upload \`brainsait_ai_course_backup.mbz\` to $LMS_URL
- **Preview Presentation**: http://95.177.160.74:8081/interactive-presentation.html
- **Course Repository**: https://github.com/Fadil369/academy

## 📋 Next Steps for LMS Administrator
1. Log into $LMS_URL as administrator
2. Go to Site Administration > Courses > Restore course
3. Upload the \`brainsait_ai_course_backup.mbz\` file
4. Follow the restore wizard to import the complete course
5. Assign instructors and enroll students
6. Test all course components

## 🎯 Course Features
- ✅ 4 comprehensive modules covering AI content creation
- ✅ Interactive presentations with navigation
- ✅ Hands-on coding examples and demos
- ✅ Assessment quizzes for each module
- ✅ Progressive learning structure
- ✅ Mobile-friendly responsive design

## 🔧 Technical Specifications
- **Platform**: Moodle 4.3+ compatible
- **Format**: Moodle backup (.mbz)
- **Content Type**: Mixed (HTML, interactive elements, assessments)
- **Estimated Duration**: 6-8 hours
- **Difficulty Level**: Intermediate

## 📞 Support
- **Technical Support**: Available through academy repository
- **Documentation**: Complete API docs and guides included
- **Community**: Join our developer community for ongoing support

---
*Deployed by BrainsAIT Academy Deployment System*
EOF

echo "✅ Deployment summary created: deployment_summary.md"

# Step 6: Final validation
echo "🔍 Step 6: Final validation..."

# Check server files
echo "   Validating server deployment..."
ssh -i $SERVER_KEY $SERVER_HOST "ls -la $SERVER_COURSE_DIR/"

echo ""
echo "🎉 DEPLOYMENT COMPLETE!"
echo "========================"
echo ""
echo "✅ Course successfully deployed to server"
echo "✅ Moodle backup ready for LMS import"
echo "✅ Interactive presentation available online"
echo ""
echo "🌐 Next Steps:"
echo "   1. Import brainsait_ai_course_backup.mbz into $LMS_URL"
echo "   2. Preview presentation: http://95.177.160.74:8081/interactive-presentation.html"
echo "   3. Test all course functionality"
echo ""
echo "📁 Deployment files location:"
echo "   Server: $SERVER_HOST:$SERVER_COURSE_DIR"
echo "   Local: $LOCAL_COURSE_DIR"
echo ""
echo "🚀 Your AI-powered course is ready for students!"