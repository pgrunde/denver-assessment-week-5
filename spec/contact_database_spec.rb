require "spec_helper"

describe ContactDatabase do
  let(:contact_database) { ContactDatabase.new }

  let(:hunter) { {id: 1, username: "hunterg", password: "abc123"} }
  let(:jeff) { {id: 2, username: "jt", password: "jeff"} }

  describe "#insert" do
    it "returns the object if it succeeds" do
      contact_as_hash = {:name => "Jeff", :email => "jetaggart@example.com", user_id: hunter[:id]}

      result = contact_database.insert(contact_as_hash)

      expect(result).to include({:name => "Jeff", :email => "jetaggart@example.com"})
    end

    it "gives the contact an id" do
      contact_as_hash = {:name => "Jeff", :email => "jetaggart@example.com", user_id: hunter[:id]}

      contact = contact_database.insert(contact_as_hash)

      expect(contact[:id]).to eq(1)
    end

    it "offsets the id by how many contacts exist" do
      contact_database.insert({:name => "Jeff", :email => "jetaggart@example.com", user_id: hunter[:id]})
      second_contact = contact_database.insert(:name => "Hunter", :email => "hunter@example.com")

      expect(second_contact[:id]).to eq(2)
    end
  end

  describe "#find_for_user" do
    it "returns only the contacts for the given user id" do
      contact_1 = {:name => "Jeff", :email => "jetaggart@example.com", user_id: hunter[:id]}
      contact_2 = {:name => "Spencer", :email => "spencer@example.com", user_id: hunter[:id]}
      contact_3 = {:name => "Bob", :email => "spencer@example.com", user_id: jeff[:id]}

      contact_database.insert(contact_1)
      contact_database.insert(contact_2)
      contact_database.insert(contact_3)

      hunters_contacts = contact_database.find_for_user(hunter[:id])

      expect(hunters_contacts.length).to eq(2)

      expect(hunters_contacts[0]).to include(name: "Jeff")
      expect(hunters_contacts[1]).to include(name: "Spencer")

      jeffs_contacts = contact_database.find_for_user(jeff[:id])

      expect(jeffs_contacts.length).to eq(1)
      expect(jeffs_contacts[0]).to include(name: "Bob")
    end
  end
end
