//
//  CoreDataManager.swift
//  TodoUp
//
//  Created by user on 2023/04/09.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // 임시저장소
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    // 아이템 배열
    var itemList: [Item] = []
    
    // 엔터티 이름 (코어데이터에 저장된 객체)
    let modelName: String = Constants.DBinfo.modelName
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getItemListFromCoreData() -> [Item] {
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 정렬순서를 정해서 요청서에 넘겨주기
            let dateOrder = NSSortDescriptor(key: Constants.DBinfo.createDate, ascending: false)
            request.sortDescriptors = [dateOrder]
            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                if let fetchedItemList = try context.fetch(request) as? [Item] {
                    itemList = fetchedItemList
                }
            } catch {
             
            }
        }
        return itemList
    }
    
    
    // MARK: - [READ] 받아온 값 검색
    func getItemListFromCoreDataByKeyword(content: String?) -> [Item] {
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            
            if let searchContent = content, searchContent != "" {
                request.predicate = NSPredicate(format: "content CONTAINS[cd] %@", searchContent)
            }
            
            // 정렬순서를 정해서 요청서에 넘겨주기
            let dateOrder = NSSortDescriptor(key: Constants.DBinfo.createDate, ascending: false)
            request.sortDescriptors = [dateOrder]
        
            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                if let fetchedItemList = try context.fetch(request) as? [Item] {
                    itemList = fetchedItemList
                    
                }
            } catch {
                
            }
        }
        return itemList
        
    }
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func saveItem(itemText: String?, colorInt: Int64, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = context {
            
            var targetItemId: Int64 = 0
            
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 정렬순서를 정해서 요청서에 넘겨주기
            let idOrder = NSSortDescriptor(key: Constants.DBinfo.itemId, ascending: false)
            request.sortDescriptors = [idOrder]
          
            do {
                if let fetchedItemList = try context.fetch(request) as? [Item] {
                    if(!fetchedItemList.isEmpty){
                        guard let targetItem = fetchedItemList.first else {return}
                        targetItemId = targetItem.itemid
                    }
                }
            } catch {
                
            }
            // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                
                // 임시저장소에 올라가게 할 객체만들기 (NSManagedObject ===> Item)
                if let item = NSManagedObject(entity: entity, insertInto: context) as? Item {
                    
                    // MARK: - Item에 실제 데이터 할당 ⭐️
                    item.content = itemText
                    item.checkdone = false
                    item.createdate = Date()   // 날짜는 저장하는 순간의 날짜로 생성
                    item.color = colorInt
                    item.itemid = targetItemId + 1
                    
                    //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print(error)
                            completion()
                        }
                    }
                }
            }
        }
        completion()
    }
    
        // MARK: - [Update] 코어데이터에서 체크 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
        func updateCheckDone(updateItem: Item, completion: @escaping () -> Void) {
            let itemid = updateItem.itemid
            
            // 임시저장소 있는지 확인
            if let context = context {
                // 요청서
                let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
                // 단서 / 찾기 위한 조건 설정
                request.predicate = NSPredicate(format: "itemid == %@", NSNumber(value: Int(itemid)))

                do {
                    // 요청서를 통해서 데이터 가져오기
                    if let fetchedItemList = try context.fetch(request) as? [Item] {
                        // 배열의 첫번째
                        if var targetItem = fetchedItemList.first {
                            // MARK: - ToDoData에 실제 데이터 재할당(바꾸기) ⭐️
                            targetItem = updateItem
                            
                            //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                            if context.hasChanges {
                                do {
                                    try context.save()
                                    completion()
                                } catch {
                                    print(error)
                                    completion()
                                }
                            }
                        }
                    }
                    completion()
                } catch {
                    completion()
                }
            }
        }
    
    
    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
    func deleteItem(data: Item, completion: @escaping () -> Void) {
        let itemid = data.itemid

        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "itemid == %@", NSNumber(value: Int(itemid)))

            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fetchedItemList = try context.fetch(request) as? [Item] {
                    
                    // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                    if let targetItem = fetchedItemList.first {
                        context.delete(targetItem)
                        //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                completion()
            }
        }
    }

    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
    func updateItem(updateItem: Item, completion: @escaping () -> Void) {
        // 날짜 옵셔널 바인딩
        let itemid = updateItem.itemid
        
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "itemid == %@", NSNumber(value: Int(itemid)))

            do {
                // 요청서를 통해서 데이터 가져오기
                if let fetchedItemList = try context.fetch(request) as? [Item] {
                    // 배열의 첫번째
                    if var targetItem = fetchedItemList.first {

                        // MARK: - ToDoData에 실제 데이터 재할당(바꾸기) ⭐️
                        targetItem = updateItem
                        targetItem.createdate = Date()
                        //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                completion()
            }
        }
    }
}

