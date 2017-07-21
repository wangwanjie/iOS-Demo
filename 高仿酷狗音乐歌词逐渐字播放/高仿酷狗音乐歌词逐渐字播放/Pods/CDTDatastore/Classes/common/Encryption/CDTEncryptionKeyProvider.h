//
//  CDTEncryptionKeyProvider.h
//
//
//  Created by Enrique de la Torre Fernandez on 20/02/2015.
//
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//  http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.
//

#import <Foundation/Foundation.h>

#import "CDTEncryptionKey.h"

@protocol CDTEncryptionKeyProvider

/**
 * Return a key that will be used to cipher the data in the datastore. If it returns nil, data will
 * not be encrypted.
 *
 * @return A key or nil
 *
 * @warning *Warning:* Encryption will not work unless subspec 'CDTDatastore/SQLCipher' is used.
 * However, data will not be encrypted if this method returns nil (regardless of the subspec).
 */
- (CDTEncryptionKey *)encryptionKey;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com