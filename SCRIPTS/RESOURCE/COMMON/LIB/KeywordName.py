from robot.libraries.BuiltIn import BuiltIn

class KeywordName(object):
    ROBOT_LISTENER_API_VERSION = 2
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self):
        self.ROBOT_LIBRARY_LISTENER = self
        self.keywords = []

    def _start_keyword(self, name, attrs):
        self.keywords.append(name)

    def _end_keyword(self, name, attrs):
        self.keywords.pop()

    def keyword_name(self):
        message = "{keyword}"
        name =message.format(
            keyword=self.keywords[0]
        )
        return name