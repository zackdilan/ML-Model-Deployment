from unittest import TestCase
from helpers.zero_shot_text_classifier import ZeroShotTextClassifier


class TestModel(TestCase):
    def setUp(self) -> None:
        ZeroShotTextClassifier.load()

    def test_predict(self):
        prediction = ZeroShotTextClassifier.predict("one day I will see the world", ['travel', 'cooking', 'dancing'])
        self.assertEqual(prediction['label'], 'travel')
        self.assertGreater(prediction['score'], 0.9)
