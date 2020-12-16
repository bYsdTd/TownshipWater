using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SeaRenderer : MonoBehaviour
{

    public int seaWidth = 15;
    public int seaHeight = 30;
    public Material seaMaterial;
    Mesh            seaMesh;
    MeshRenderer    seaMeshRenderer;
    MeshFilter      seaMeshFilter;

    // Start is called before the first frame update
    void Start()
    {
        seaMeshRenderer = gameObject.AddComponent<MeshRenderer>();
        seaMeshFilter = gameObject.AddComponent<MeshFilter>();
        seaMeshRenderer.sharedMaterial = seaMaterial;

        UpdateMesh();
    }

    void UpdateMesh()
    {
        if (seaMesh == null)
        {
            seaMesh = new Mesh();
            seaMesh.name = "seaMesh";
            seaMeshFilter.mesh = seaMesh;
        }

        seaMesh.Clear();
        
        // 常量定义
        int quadCount = seaWidth * seaHeight;
        float xoffset = 2;
        float yoffset = 1;

        Vector3[] vertices = new Vector3[4 * quadCount];
		int[]	indices = new int[6 * quadCount];

        for (int row = 0; row < seaHeight; row++)
        {
            float curX = row % 2 == 0 ? 0 : xoffset/2;
            float curY = row * yoffset / 2;
            for (int col = 0; col < seaWidth; col++)
            {
                int index = row * seaWidth + col;
                vertices[index*4] = new Vector3(curX-xoffset/2, curY, 0);
                vertices[index*4+1] = new Vector3(curX, curY-yoffset/2, 0);
                vertices[index*4+2] = new Vector3(curX+xoffset/2, curY, 0);
                vertices[index*4+3] = new Vector3(curX, curY+yoffset/2, 0);

                indices[index*6] = index*4;
                indices[index*6+1] = index*4+2;
                indices[index*6+2] = index*4+1;
                indices[index*6+3] = index*4;
                indices[index*6+4] = index*4+3;
                indices[index*6+5] = index*4+2;

                curX += xoffset;
            }
        }

		seaMesh.vertices = vertices;
		seaMesh.triangles = indices;
    }
}
