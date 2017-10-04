// Copyright 2017 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef TRAININGDATA_HPP
#define TRAININGDATA_HPP

#include <cstdint>
#include <map>
#include <string>
#include <vector>

#include "util.hpp"

class TrainingData {
public:
  TrainingData(const std::string& directory);
  bool Load();
  std::vector<FeatureHash>* GetFeaturesVector();
  std::vector<std::pair<uint32_t, uint32_t>>* GetAttractionSet();
  std::vector<std::pair<uint32_t, uint32_t>>* GetRepulsionSet();
  std::vector<FunctionFeatures>* GetFunctions();
private:
  std::string directory_;
  bool loaded_;
  std::set<FeatureHash> all_features_;
  std::vector<FeatureHash> all_features_vector_;
  std::map<FeatureHash, uint32_t> feature_to_vector_index_;
  std::vector<FunctionFeatures> all_functions_;
  std::map<std::string, uint32_t> function_to_index_;
  std::vector<std::pair<uint32_t, uint32_t>> attractionset_;
  std::vector<std::pair<uint32_t, uint32_t>> repulsionset_;
};

#endif