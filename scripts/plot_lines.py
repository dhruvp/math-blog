import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


t = np.linspace(-1,1,10)

fig = plt.figure()
ax = fig.gca(projection='3d')
x = -t/2
y = t
z = -t/3

x1 = (1-t)/2
y1 = t
z1 = (1-t)/3

# ax.plot(x, y, z, label=r'$K$')
ax.plot(x1, y1, z1, label=r'$f^{-1}([1;1])$', color='orange')
ax.legend()

ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')

plt.setp( ax.get_xticklabels(), visible=False)
plt.setp( ax.get_yticklabels(), visible=False)
plt.setp( ax.get_zticklabels(), visible=False)


plt.show()
