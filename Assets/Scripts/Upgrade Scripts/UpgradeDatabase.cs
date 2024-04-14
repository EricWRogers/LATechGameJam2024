using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

/*[System.Serializable]
public struct DialogueBox
{
    public string Name;
    public Sprite Icon;
    public string Description;
}*/

public class UpgradeDatabase : MonoBehaviour
{
    public List<GameObject> objectsToSpawn;
    public List<Transform> spawnPoints;
    public float timeBetweenSpawns = 60f;
    public float nextSpawnTime;
    public int spawnPointIndex=0;
    public List<Upgrade> upgrades;

    // Start is called before the first frame update
    void Start()
    {
        ShuffleList(objectsToSpawn);
        ShuffleList(spawnPoints);
        ShuffleList(upgrades);
    }

    // Update is called once per frame
    void Update()
    {
        if (Time.time >= nextSpawnTime)
        {
            SpawnObject();
            if(spawnPointIndex < spawnPoints.Count-1)
            {
                spawnPointIndex++;
            }
            nextSpawnTime = Time.time + timeBetweenSpawns;
        }
        
    }

    void SpawnObject()
    {
        ShuffleList(upgrades);
        // Spawn the next object in the list
        GameObject objToSpawn = objectsToSpawn[spawnPointIndex % objectsToSpawn.Count];
        Instantiate(objToSpawn, spawnPoints[spawnPointIndex].position, Quaternion.identity);
        objToSpawn.GetComponent<UpgradeHolder>().upgrade = upgrades[0];
    }

    private void ShuffleList<T>(List<T> list)
    {
        int n = list.Count;
        while (n > 1)
        {
            n--;
            int k = Random.Range(0, n + 1);
            T value = list[k];
            list[k] = list[n];
            list[n] = value;
        }
    }

    
}
