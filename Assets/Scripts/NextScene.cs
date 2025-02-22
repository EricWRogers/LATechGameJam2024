using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class NextScene : MonoBehaviour
{
    public void GoToScene(string sceneName)
    {
        Time.timeScale = 1.0f;
        SceneManager.LoadSceneAsync(sceneName);
    }
}
