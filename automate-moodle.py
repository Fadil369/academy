#!/usr/bin/env python3
import requests
import json

class MoodleAutomator:
    def __init__(self, moodle_url, token):
        self.moodle_url = moodle_url
        self.token = token
        self.api_url = f"{moodle_url}/webservice/rest/server.php"
    
    def call_moodle_api(self, function, params={}):
        """Call Moodle Web Service API"""
        data = {
            'wstoken': self.token,
            'wsfunction': function,
            'moodlewsrestformat': 'json',
            **params
        }
        response = requests.post(self.api_url, data=data)
        return response.json()
    
    def create_course(self, name, shortname, category_id=1, description=""):
        """Create a new course"""
        params = {
            'courses[0][fullname]': name,
            'courses[0][shortname]': shortname,
            'courses[0][categoryid]': category_id,
            'courses[0][summary]': description
        }
        return self.call_moodle_api('core_course_create_courses', params)
    
    def add_resource(self, course_id, name, content):
        """Add a page resource to course"""
        params = {
            'activities[0][courseid]': course_id,
            'activities[0][name]': name,
            'activities[0][modulename]': 'page',
            'activities[0][intro]': content,
            'activities[0][introformat]': 1
        }
        return self.call_moodle_api('core_course_create_activities', params)

# Example usage with your Moodle instance
def main():
    # Configure these for your Moodle setup
    MOODLE_URL = "https://your-moodle.com"
    MOODLE_TOKEN = "your-webservice-token"
    
    automator = MoodleAutomator(MOODLE_URL, MOODLE_TOKEN)
    
    # Create course
    course_result = automator.create_course(
        "AI Fundamentals", 
        "ai_fundamentals",
        description="Introduction to Artificial Intelligence concepts"
    )
    
    print(f"Course created: {course_result}")

if __name__ == "__main__":
    main()
