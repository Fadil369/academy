#!/usr/bin/env python3
# Mirrors repository-level moodle-packager.py for plugin self-containment.

import json
import zipfile
import os
import xml.etree.ElementTree as ET
from datetime import datetime
import shutil

class MoodleCoursePackager:
    def __init__(self, course_export_dir="course_export"):
        self.course_dir = course_export_dir
        self.package_dir = f"{course_export_dir}/moodle_package"
        self.backup_id = f"brainsait_ai_course_{int(datetime.now().timestamp())}"
        
    def create_moodle_package(self):
        os.makedirs(self.package_dir, exist_ok=True)
        os.makedirs(f"{self.package_dir}/activities", exist_ok=True)
        os.makedirs(f"{self.package_dir}/sections", exist_ok=True)
        os.makedirs(f"{self.package_dir}/files", exist_ok=True)
        
        self._create_moodle_backup_xml()
        self._create_course_xml()
        self._create_sections()
        self._create_activities()
        self._copy_resource_files()
        
        backup_file = self._create_backup_zip()
        print(f"✅ Moodle course package created: {backup_file}")
        return backup_file
    
    def _create_moodle_backup_xml(self):
        root = ET.Element("moodle_backup")
        info = ET.SubElement(root, "information")
        ET.SubElement(info, "name").text = "AI-Powered Content Creation Course"
        ET.SubElement(info, "moodle_version").text = "2023100900"
        ET.SubElement(info, "moodle_release").text = "4.3"
        ET.SubElement(info, "backup_version").text = "2023100900"
        ET.SubElement(info, "backup_release").text = "4.3"
        ET.SubElement(info, "backup_date").text = str(int(datetime.now().timestamp()))
        ET.SubElement(info, "mnet_remoteusers").text = "0"
        ET.SubElement(info, "include_file_references_to_external_content").text = "0"
        ET.SubElement(info, "original_wwwroot").text = "https://lms.brainsait.com"
        ET.SubElement(info, "original_site_identifier_hash").text = "brainsait_academy"
        ET.SubElement(info, "original_course_id").text = "1"
        ET.SubElement(info, "original_course_format").text = "topics"
        ET.SubElement(info, "original_course_fullname").text = "AI-Powered Content Creation and LMS Integration"
        ET.SubElement(info, "original_course_shortname").text = "AI_CONTENT_2025"
        ET.SubElement(info, "original_course_startdate").text = str(int(datetime.now().timestamp()))
        ET.SubElement(info, "original_course_contextid").text = "1"
        ET.SubElement(info, "original_system_contextid").text = "1"
        
        details = ET.SubElement(root, "details")
        detail = ET.SubElement(details, "detail")
        detail.set("backup_id", self.backup_id)
        detail.set("type", "course")
        detail.set("format", "moodle2")
        detail.set("interactive", "1")
        detail.set("mode", "10")
        detail.set("execution", "1")
        detail.set("executiontime", "0")
        
        contents = ET.SubElement(root, "contents")
        activities = ET.SubElement(contents, "activities")
        for i in range(1, 13):
            activity = ET.SubElement(activities, "activity")
            activity.set("moduleid", str(i))
            activity.set("sectionid", str((i-1)//3 + 1))
            activity.set("modulename", "page" if i % 3 != 0 else "quiz")
            activity.set("title", f"Lesson {i}" if i % 3 != 0 else f"Module {(i-1)//3 + 1} Assessment")
            activity.set("directory", f"activities/page_{i}" if i % 3 != 0 else f"activities/quiz_{i}")
        
        sections = ET.SubElement(contents, "sections")
        for i in range(5):
            section = ET.SubElement(sections, "section")
            section.set("sectionid", str(i))
            section.set("title", "General" if i == 0 else f"Module {i}")
            section.set("directory", f"sections/section_{i}")
        
        course_elem = ET.SubElement(contents, "course")
        course_elem.set("courseid", "1")
        course_elem.set("title", "AI-Powered Content Creation and LMS Integration")
        course_elem.set("directory", "course")
        
        tree = ET.ElementTree(root)
        try:
            ET.indent(tree, space="  ", level=0)
        except Exception:
            pass
        tree.write(f"{self.package_dir}/moodle_backup.xml", encoding="utf-8", xml_declaration=True)
    
    def _create_course_xml(self):
        os.makedirs(f"{self.package_dir}/course", exist_ok=True)
        root = ET.Element("course")
        root.set("id", "1")
        root.set("contextid", "1")
        ET.SubElement(root, "shortname").text = "AI_CONTENT_2025"
        ET.SubElement(root, "fullname").text = "AI-Powered Content Creation and LMS Integration"
        ET.SubElement(root, "idnumber").text = "BRAINSAIT_AI_001"
        ET.SubElement(root, "summary").text = "A comprehensive course covering AI content generation, MCP integration, and Moodle deployment for modern educational technology."
        ET.SubElement(root, "summaryformat").text = "1"
        ET.SubElement(root, "format").text = "topics"
        ET.SubElement(root, "showgrades").text = "1"
        ET.SubElement(root, "newsitems").text = "5"
        ET.SubElement(root, "startdate").text = str(int(datetime.now().timestamp()))
        ET.SubElement(root, "enddate").text = "0"
        ET.SubElement(root, "marker").text = "0"
        ET.SubElement(root, "maxbytes").text = "0"
        ET.SubElement(root, "legacyfiles").text = "0"
        ET.SubElement(root, "showreports").text = "0"
        ET.SubElement(root, "visible").text = "1"
        ET.SubElement(root, "groupmode").text = "0"
        ET.SubElement(root, "groupmodeforce").text = "0"
        ET.SubElement(root, "defaultgroupingid").text = "0"
        ET.SubElement(root, "lang").text = ""
        ET.SubElement(root, "theme").text = ""
        ET.SubElement(root, "timecreated").text = str(int(datetime.now().timestamp()))
        ET.SubElement(root, "timemodified").text = str(int(datetime.now().timestamp()))
        ET.SubElement(root, "requested").text = "0"
        ET.SubElement(root, "enablecompletion").text = "1"
        ET.SubElement(root, "completionnotify").text = "0"
        ET.SubElement(root, "cacherev").text = str(int(datetime.now().timestamp()))
        
        tree = ET.ElementTree(root)
        try:
            ET.indent(tree, space="  ", level=0)
        except Exception:
            pass
        tree.write(f"{self.package_dir}/course/course.xml", encoding="utf-8", xml_declaration=True)
    
    def _create_sections(self):
        sections_data = [
            {"id": 0, "name": "General", "summary": "Welcome to the AI-Powered Content Creation Course"},
            {"id": 1, "name": "Module 1: AI Content Creation Fundamentals", "summary": "Understanding the basics of AI-powered content generation"},
            {"id": 2, "name": "Module 2: Model Context Protocol (MCP)", "summary": "Deep dive into MCP for seamless AI integration"},
            {"id": 3, "name": "Module 3: Moodle Integration", "summary": "Implementing AI content generation in Moodle LMS"},
            {"id": 4, "name": "Module 4: Advanced Features", "summary": "Exploring cutting-edge AI capabilities and future trends"}
        ]
        
        for section_data in sections_data:
            section_dir = f"{self.package_dir}/sections/section_{section_data['id']}"
            os.makedirs(section_dir, exist_ok=True)
            
            root = ET.Element("section")
            root.set("id", str(section_data['id']))
            ET.SubElement(root, "number").text = str(section_data['id'])
            ET.SubElement(root, "name").text = section_data['name']
            ET.SubElement(root, "summary").text = section_data['summary']
            ET.SubElement(root, "summaryformat").text = "1"
            ET.SubElement(root, "sequence").text = ""
            ET.SubElement(root, "visible").text = "1"
            ET.SubElement(root, "availabilityjson").text = ""
            ET.SubElement(root, "timemodified").text = str(int(datetime.now().timestamp()))
            
            tree = ET.ElementTree(root)
            try:
                ET.indent(tree, space="  ", level=0)
            except Exception:
                pass
            tree.write(f"{section_dir}/section.xml", encoding="utf-8", xml_declaration=True)
    
    def _create_activities(self):
        modules = []
        for i in range(1, 5):
            with open(f"{self.course_dir}/module_{i}.json", 'r') as f:
                modules.append(json.load(f))
        
        activity_id = 1
        for module in modules:
            for lesson in module['lessons']:
                activity_dir = f"{self.package_dir}/activities/page_{activity_id}"
                os.makedirs(activity_dir, exist_ok=True)
                
                root = ET.Element("activity")
                root.set("id", str(activity_id))
                root.set("moduleid", str(activity_id))
                root.set("modulename", "page")
                root.set("contextid", str(activity_id + 100))
                
                page = ET.SubElement(root, "page")
                page.set("id", str(activity_id))
                ET.SubElement(page, "name").text = lesson['title']
                ET.SubElement(page, "intro").text = "Lesson"
                ET.SubElement(page, "introformat").text = "1"
                ET.SubElement(page, "content").text = lesson['content']
                ET.SubElement(page, "contentformat").text = "1"
                ET.SubElement(page, "legacyfiles").text = "0"
                ET.SubElement(page, "legacyfileslast").text = ""
                ET.SubElement(page, "display").text = "5"
                ET.SubElement(page, "displayoptions").text = "a:1:{s:12:\"printheading\";s:1:\"1\";}"
                ET.SubElement(page, "revision").text = "1"
                ET.SubElement(page, "timemodified").text = str(int(datetime.now().timestamp()))
                
                tree = ET.ElementTree(root)
                try:
                    ET.indent(tree, space="  ", level=0)
                except Exception:
                    pass
                tree.write(f"{activity_dir}/page.xml", encoding="utf-8", xml_declaration=True)
                
                activity_id += 1
    
    def _copy_resource_files(self):
        shutil.copy(f"{self.course_dir}/interactive-presentation.html", 
                   f"{self.package_dir}/files/presentation.html")
        with open(f"{self.package_dir}/files/index.html", 'w') as f:
            f.write("""
<!DOCTYPE html>
<html>
<head>
    <title>BrainsAIT AI Course Resources</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .resource { background: #f5f5f5; padding: 20px; margin: 20px 0; border-radius: 10px; }
    </style>
</head>
<body>
    <h1>AI-Powered Content Creation Course Resources</h1>
    <div class="resource">
        <h2>Interactive Presentation</h2>
        <p>View the complete course slides with interactive elements.</p>
        <a href="presentation.html" target="_blank">Open Presentation</a>
    </div>
</body>
</html>
            """)
    
    def _create_backup_zip(self):
        backup_filename = f"{self.course_dir}/brainsait_ai_course_backup.mbz"
        with zipfile.ZipFile(backup_filename, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for root, _, files in os.walk(self.package_dir):
                for file in files:
                    file_path = os.path.join(root, file)
                    arcname = os.path.relpath(file_path, self.package_dir)
                    zipf.write(file_path, arcname)
        return backup_filename

if __name__ == "__main__":
    packager = MoodleCoursePackager()
    backup_file = packager.create_moodle_package()
    print(f"Ready for upload to https://lms.brainsait.com")
    print(f"Backup file: {backup_file}")
