#!/usr/bin/env python3
import json
import sys

def generate_content(topic, content_type="lesson"):
    """Generate educational content"""
    templates = {
        "course": f"Comprehensive {topic} course covering fundamental concepts and practical applications.",
        "lesson": f"""
        <h2>{topic}</h2>
        <p>Learning objectives for {topic}:</p>
        <ul>
            <li>Understand core concepts</li>
            <li>Apply practical skills</li>
            <li>Complete hands-on exercises</li>
        </ul>
        <p>Content for {topic} will be developed based on current industry standards.</p>
        """
    }
    return templates.get(content_type, f"Content for {topic}")

def handle_mcp_request():
    """Handle MCP protocol requests"""
    for line in sys.stdin:
        try:
            request = json.loads(line)
            
            if request.get("method") == "tools/list":
                response = {
                    "jsonrpc": "2.0",
                    "id": request.get("id"),
                    "result": {
                        "tools": [
                            {
                                "name": "generate_description",
                                "description": "Generate course descriptions"
                            },
                            {
                                "name": "generate_lesson", 
                                "description": "Generate lesson content"
                            }
                        ]
                    }
                }
                print(json.dumps(response))
                
            elif request.get("method") == "tools/call":
                tool_name = request["params"]["name"]
                args = request["params"].get("arguments", {})
                
                if tool_name == "generate_description":
                    content = generate_content(args.get("topic", ""), "course")
                elif tool_name == "generate_lesson":
                    content = generate_content(args.get("topic", ""), "lesson")
                else:
                    content = "Unknown tool"
                
                response = {
                    "jsonrpc": "2.0",
                    "id": request.get("id"),
                    "result": {
                        "content": [{"type": "text", "text": content}]
                    }
                }
                print(json.dumps(response))
                
        except Exception as e:
            error_response = {
                "jsonrpc": "2.0",
                "id": request.get("id") if 'request' in locals() else None,
                "error": {"code": -1, "message": str(e)}
            }
            print(json.dumps(error_response))

if __name__ == "__main__":
    handle_mcp_request()
