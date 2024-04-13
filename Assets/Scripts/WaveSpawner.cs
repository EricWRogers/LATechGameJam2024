using System.Collections.Generic;
using UnityEngine;

public class WaveSpawner : MonoBehaviour
{
    public List<GameObject> objectsToSpawn; // List of game objects to spawn
    public float timeBetweenSpawns = 1f; // Delay between spawns
    public float timeBetweenWaves = 5f; // Delay between waves
    public int totalWaves = 3; // Total number of waves

    private float nextSpawnTime; // Time to spawn next object
    private int currentWave = 0; // Current wave index

    void Start()
    {
        // Start spawning waves
        SpawnWave();
    }

    void Update()
    {
        // Check if it's time to spawn the next object
        if (Time.time >= nextSpawnTime)
        {
            SpawnObject();
            nextSpawnTime = Time.time + timeBetweenSpawns;
        }
    }

    void SpawnObject()
    {
        // Spawn the next object in the list
        GameObject objToSpawn = objectsToSpawn[currentWave % objectsToSpawn.Count];
        Instantiate(objToSpawn, transform.position, Quaternion.identity);
    }

    void SpawnWave()
    {
        // Check if we've completed all waves
        if (currentWave >= totalWaves)
        {
            Debug.Log("Winning!");
            return;
        }

        // Increment the current wave index
        currentWave++;

        // Schedule the next wave
        Invoke("SpawnWave", timeBetweenWaves);
    }
}
