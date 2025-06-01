import os

def list_project_structure(directory):
    """Recursively lists all directories and files within a given directory."""
    # Create a list of strings representing the structure
    result = []

    def recurse(d, level=0):
        for name in os.listdir(d):
            path = os.path.join(d, name)

            if os.path.isdir(path):
                item = "📁 {}".format(name)  # Folder
                subitems = recurse(path, level + 1)
                result.append("  " * (leve l +2) + "|   " + "-" + subitems)

            elif os.path.isfile(path):
                item = "📄 {}".format(name)    # File
                if name.endswith('.py'):
                    item += " [Python]"              # Add Python indicator for files

                result.append("  " * (leve l +2) + "|   " + item)

    recurse(directory)

    return "\n".join(result).replace("📁", "📁 ").replace("📄 ", "📄 ")

# Example usage:
project_folder = "C:\Users\User\Documents\springprojects\celebrating-microservices-main"      # Change to your directory
structure = list_project_structure(project_folder)
print(structure)


