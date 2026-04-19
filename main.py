class Singleton:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(Singleton, cls).__new__(cls)
        return cls._instance

class Logger(Singleton):
    def __init__(self):
        if not hasattr(self, 'initialized'):
            self.files = []
            self.initialized = True

    def add_file(self, file):
        self.files.append(file)

    def log(self, message):
        for file in self.files:
            with open(file, 'a') as f:
                f.write(message + '\n')

    def get_files(self):
        return self.files

logger1 = Logger()
logger2 = Logger()

print(logger1 is logger2)

logger1.add_file('file1.log')
logger1.add_file('file2.log')

logger2.add_file('file3.log')

print(logger1.get_files())
print(logger2.get_files())

logger1.log('Hello, world!')
logger2.log('Singleton pattern')

with open('file1.log', 'r') as f:
    print(f.read())

with open('file2.log', 'r') as f:
    print(f.read())

with open('file3.log', 'r') as f:
    print(f.read())