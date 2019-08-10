# Binary Tree 二叉树

## 基本概念

满二叉树/完美二叉树(Perfect Binary Tree): 除了叶子结点之外的每一个结点都有两个孩子，每一层(当然包含最后一层)都被完全填充。

完全二叉树(Complete Binary Tree)：除了最后一层之外的其他每一层都被完全填充，并且所有结点都保持向左对齐。

真二叉树/完满二叉树(Full/Strictly Binary Tree)：除了叶子结点之外的每一个结点都有两个孩子结点。

注意：国内教材的概念与英语的直译并不完全对应。

更加直观和详细的树结构的基本概念参考[this blog](http://www.cnblogs.com/idorax/p/6441043.html)

多叉树与二叉树的等价性：通过长子兄弟法可以将一棵任意多叉树转化为一棵二叉树，因此可以认为多叉树等价于二叉树，对于树结构的研究可集中于对二叉树的研究。

## 二叉树的遍历

二叉树的遍历有前序遍历，中序遍历，后序遍历和层次遍历。其中层次遍历对应于图的宽度优先遍历,其他三种遍历方式都可以对应于深度优先遍历。前序遍历，中序遍历，后序遍历分别按照根左右，左根右和左右根的次序对树进行遍历。根左右意为对于遍历时二叉树中的每个结点，都先访问其自身，然后完成其左子树的访问后再对其右子树进行访问，其他以此类推。对这三种遍历方式的实现都有迭代版本和递归版本。

给定了二叉树的`前序遍历序列和中序遍历序列`或`后序遍历序列和中序遍历序列`都可以唯一地确定一棵二叉树。（在BinaryTree.cpp中重建二叉树的参考代码中，完成了前序遍历和中序遍历序列的二叉树重建，且假定遍历序列中无重复元素，如果存在重复元素，则需要用结点指针来判断两个结点是否相等，这里为简化做此假定。）而给定`前序遍历序列和后序遍历序列`无法唯一地确定一棵二叉树，原因在于对于只有一个孩子的结点无法判断该孩子是作为左孩子还是右孩子，如果加上二叉树是满二叉树的限定，则可以唯一地确定一棵满二叉树。

二叉树的层次遍历需要一个辅助队列结构，这个队列的容量只需要二叉树结点数量的一半即可。如果需要在层次遍历过程中记录二叉树的层次信息(如每遍历完一层用'\n'标识)，则只有两个额外的指针即可。