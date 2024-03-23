from sklearn.datasets import load_iris
from sklearn.tree import DecisionTreeClassifier, plot_tree
import matplotlib.pyplot as plt

# Load the Iris dataset
iris = load_iris()
X = iris.data
y = iris.target

# Create and fit the decision tree classifier
classifier = DecisionTreeClassifier(random_state=0)
classifier.fit(X, y)

# Visualize the decision tree
plt.figure(figsize=(20,10))
plot_tree(classifier, filled=True, feature_names=iris['feature_names'], class_names=iris['target_names'])
plt.show()
