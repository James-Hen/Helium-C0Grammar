import networkx as nx
import matplotlib.pyplot as plt
from networkx.drawing.nx_agraph import graphviz_layout

G = nx.Graph()
names = {}

with open("TestFile.tree", "r") as f:
    for line in f.readlines():
        prm = line.split('\t')
        nid = int(prm[0])
        name = prm[1]
        if (nid not in G.nodes):
            G.add_node(nid)
        names[nid] = name
        chc = int(prm[2])
        for i in range(3, 3 + chc):
            G.add_edge(nid, int(prm[i]))

pos = graphviz_layout(G, prog='dot')
nx.draw_networkx_edges(G, pos, width=[1]*len(G.edges), arrows=True)
nx.draw_networkx_nodes(G, pos, node_size=[100]*len(G.nodes), node_color=[(0.7,0.7,0.9)]*len(G.nodes))
nx.draw_networkx_labels(G, pos, labels=names, font_size=10)
plt.show()